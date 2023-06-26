"
A UnitOfWork keeps track of objects which might potentially be modified and lets you roll them back or commit the changes into the database.

Instance Variables:
	newObjects	<IdentitySet of: Object>	The objects registered with us as being new (i.e. not existing already in the database)
	session	<Session>	The session in which this is all taking place.
	transaction	<ObjectTransaction>	Keeps track of the original object state so that we can revert it.
	rowMap	<RowMap>	A holder for the rows when we are writing out changes.
	commitPlan	<(OrderedCollection of: DatabaseRow)>	The list of rows to be written, in order. Constructed by topological sorting the contents of the row map.
	calculatingRows <Boolean> Are we in the process of computing the rows to be written. If so, we should not be doing reads and registrations - it's probably an error in the mapping code by accidentally forcing a read.


"
Class {
	#name : #UnitOfWork,
	#superclass : #Object,
	#instVars : [
		'session',
		'transaction',
		'deletedObjects',
		'newObjects',
		'rowMap',
		'commitPlan',
		'deletePlan',
		'rowsByTable',
		'succeeded',
		'linkRowsForUpdate',
		'commitPhase',
		'deleting'
	],
	#category : #'Glorp-UnitOfWork'
}

{ #category : #'begin/commit/abort' }
UnitOfWork >> abort [
	self reinitialize.
]

{ #category : #'begin/commit/abort' }
UnitOfWork >> abort: anObject [
	transaction abort: anObject
]

{ #category : #'private/mapping' }
UnitOfWork >> addObject: eachObject toCacheKeyedBy: key [ 

	| tracker |	
	self session cacheAt: key put: eachObject.
	tracker := self session modificationTracker.
	tracker isNil ifFalse: [tracker track: eachObject]
]

{ #category : #'private/mapping' }
UnitOfWork >> addToCommitPlan: aRow [
	aRow shouldBeWritten ifFalse: [^self].
	commitPlan add: aRow
]

{ #category : #'private/mapping' }
UnitOfWork >> addToDeletePlan: aRow [
	
	deletePlan add: aRow
]

{ #category : #'private/mapping' }
UnitOfWork >> assignSequenceNumbers [
	commitPlan do: [:each | each preWriteAssignSequencesUsing: self session].
]

{ #category : #'begin/commit/abort' }
UnitOfWork >> begin [
	self reinitialize.
]

{ #category : #'private/mapping' }
UnitOfWork >> buildCommitPlan [
	| tablesInCommitOrder |
	commitPlan := OrderedCollection new.
	deletePlan := OrderedCollection new.
	tablesInCommitOrder := session tablesInCommitOrder.
	tablesInCommitOrder do: 
			[:eachTable | 
			self rowsForTable: eachTable
				do: 
					[:eachRow | 
					eachRow forDeletion 
						ifTrue: [self addToDeletePlan: eachRow]
						ifFalse: [self addToCommitPlan: eachRow]]].
	self sortCommitPlanRows
]

{ #category : #'begin/commit/abort' }
UnitOfWork >> commit [
	[self preCommit.
	self writeRows] ifCurtailed: [succeeded := false].
	succeeded
		ifTrue: [self postCommit]
		ifFalse:
			[GlorpTransactionFailure signal]
]

{ #category : #deletion }
UnitOfWork >> computeCollectionDeletes [
	"If we have objects that are part of exclusive collections, and they have been removed from those collections, then they must be deleted. Note that we do this *before* we register the transitive closure at the end of the unit of work. That means we won't know about any new objects yet, but we don't care because new objects won't be deleted in this way. And that way if we delete and then add another object with (ick) the same primary key, we shouldn't have a clash because the delete will already have been issued."

	self registeredObjects do: [:each |
		| descriptor |
		(descriptor := session descriptorFor: each class) isNil
			ifFalse: [descriptor mappings do: [:eachMapping |
				self computeCollectionDeletesFor: eachMapping inObject: each]]].
]

{ #category : #deletion }
UnitOfWork >> computeCollectionDeletesFor: aMapping inObject: anObject [
	"Figure out which, if any, dependent objects we should delete based on changes to the corresponding collection in anObject"
	| collection memento collectionMemento |
	aMapping isExclusive ifFalse: [^self].
	aMapping attribute isCollectionAttribute ifFalse: [^self].
	collection := aMapping getValueFrom: anObject.
	collection := self session realObjectFor: collection ifNone: [^self].
	(aMapping isValidTarget: collection) ifFalse: [^self].
	memento := transaction mementoFor: anObject.
	collectionMemento := transaction collectionMementoFor: (self session realObjectFor: (aMapping getValueFrom: memento)).
	"OK, now we have the state of the original collection and the new collection, we can look for differences."
	collectionMemento do: [:each |
		| matching |
		(each isGlorpProxy not or: [each isInstantiated]) ifTrue: [
			matching := collection 
				detect: [:eachElement | 
					(eachElement isGlorpProxy not or: [eachElement isInstantiated])
						and: [each yourSelf == eachElement yourSelf]]
				ifNone: [nil].
			matching == nil ifTrue: [session delete: each]
		]
	]
]

{ #category : #accessing }
UnitOfWork >> correspondenceMap [
	^transaction undoMap
]

{ #category : #'begin/commit/abort' }
UnitOfWork >> createMementoRowMapFor: objects [ 
	"Create a rowmap for the objects whose state was already known. We subtract this from the rowmap of all known objects to get the rows that need to be written. New objects are also registered, so we only generate rows here for non-new objects"

	| localRowMap |
	localRowMap := RowMapForMementos 
				withCorrespondenceMap: self correspondenceMap.
	localRowMap collectionMementos: transaction collectionMementos.
	objects keysAndValuesDo: 
			[:original :memento | 
			(self newObjects includes: original) 
				ifFalse: [session createRowsFor: memento in: localRowMap]].
	^localRowMap
]

{ #category : #'begin/commit/abort' }
UnitOfWork >> createRowMapFor: objects [
	| localRowMap |
	localRowMap := RowMap new: objects size.
	objects do: [:each | session createRowsFor: each in: localRowMap].
	^localRowMap
]

{ #category : #'begin/commit/abort' }
UnitOfWork >> createRows [
	self createRowsForPartialWrites.
]

{ #category : #'begin/commit/abort' }
UnitOfWork >> createRowsForCompleteWrites [
	"reference implementation. not called from anywhere"

	self registeredObjectsDo: [:eachObject | session createRowsFor: eachObject in: rowMap].
	deletedObjects do: [:eachObject | session createDeleteRowsFor: eachObject in: rowMap].
]

{ #category : #'begin/commit/abort' }
UnitOfWork >> createRowsForPartialWrites [
	| registeredObjectsRowMap mementoObjectsRowMap |
	registeredObjectsRowMap := self createRowMapFor: self registeredObjects.
	deletedObjects 
		do: [:eachObject | session createDeleteRowsFor: eachObject in: registeredObjectsRowMap].
	mementoObjectsRowMap := self createMementoRowMapFor: self mementoObjects.
	rowMap := registeredObjectsRowMap differenceFrom: mementoObjectsRowMap
]

{ #category : #deletion }
UnitOfWork >> delete: anObject [
	(self isRegistered: anObject) ifFalse: [session registerForDelete: anObject].
	deletedObjects add: anObject.
	(session embeddedObjectsFor: anObject) do: [:each | self delete: each]
]

{ #category : #private }
UnitOfWork >> deletedObjects [
	^deletedObjects
]

{ #category : #testing }
UnitOfWork >> forcesUpdateFor: aDatabaseRow [
	^linkRowsForUpdate notNil and: [linkRowsForUpdate includes: aDatabaseRow]
]

{ #category : #deletion }
UnitOfWork >> hasPendingDeletions [

	^deletedObjects isEmpty not
]

{ #category : #initialization }
UnitOfWork >> initialize [

	transaction := ObjectTransaction new.
	self reinitialize
]

{ #category : #'private/mapping' }
UnitOfWork >> instantiateIfRequiredFor: anObject mapping: eachMapping [
	"Sometimes we have to instantiate the targets if they weren't. Specifically, if there's a relationship where the target has a foreign key to us. e.g. if X has a 1-many to Y, and we don't instantiate the collection of Y, but then replace it with some other collection. The Y's keys have to be updated, so we need to make sure they're read. There are other cases, too"

	| originalTarget targetObject mapping instantiated |
	mapping := eachMapping applicableMappingForObject: anObject.
	mapping isRelationship ifFalse: [^false].
	mapping readOnly ifTrue: [^false].
	targetObject := mapping getValueFrom: anObject.
	(self isNewObject: anObject)
		ifTrue:
			[^self instantiateIfRequiredForNewObjectReferenceTo: targetObject].
	instantiated := (self willDelete: anObject)
		ifTrue:
			[self instantiateIfRequiredForDeletedObjectReferencing: targetObject from: anObject in: eachMapping]
		ifFalse: [false].
	originalTarget := self originalValueFor: anObject mapping: mapping.
	^instantiated or: [self
		instantiateIfRequiredForReferenceChangedFrom: originalTarget
		to: targetObject]
]

{ #category : #'private/mapping' }
UnitOfWork >> instantiateIfRequiredForDeletedObjectReferencing: targetObject from: anObject in: aMapping [
	"If we are deleted, then we need to have at least one mapping for each of our primary keys instantiated. If we're lucky, there's a direct mapping, and it's easy. Note that this only looks for the primary table. This might not be correct, but it's not clear, and for secondary tables there's a multiple table join that can be used without needing a mapping. And I'm not prepared to think about secondary tables whose keys are mapped only as relationships. In addition, if we use a link table, then we need to instantiate the reference, because we'll need to have enough information to delete the link table entry/entries."
	| mappingsToUseForPrimaryKeys |
	aMapping mapsPrimaryKeys ifFalse: [^false].	
	aMapping usesLinkTable ifTrue: [
		"Make sure we get the non-filtered version, and return false so that if the reference has changed, we'll also get the original version."
		self notFilteringDeletesDo: [targetObject yourSelf]. ^false].
	mappingsToUseForPrimaryKeys := aMapping descriptor primaryKeyMappingsFor: aMapping descriptor primaryTable.
	"For any of the fields we map, is there anyone else who can get us the value. If not, instantiate us. It might be better to optimize this a bit to look for e.g. one-one mappings before to-many."
	aMapping mappedFields do: [:each |
		| mappings |
		mappings := mappingsToUseForPrimaryKeys at: each ifAbsent: [nil].
		mappings isNil ifFalse: [
			(mappings allSatisfy: [:eachMapping | 
				(eachMapping hasValueThatCanProvideField: each from: anObject) not])
					ifTrue: [
						targetObject yourSelf.
						^true]]].
	^false
]

{ #category : #'private/mapping' }
UnitOfWork >> instantiateIfRequiredForNewObjectReferenceTo: targetObject [
	"If it's a new object, then we always need to instantiate"
	targetObject isGlorpProxy ifFalse: [^false].
	targetObject getValue.
	^true
]

{ #category : #'private/mapping' }
UnitOfWork >> instantiateIfRequiredForReferenceChangedFrom: originalTarget to: newTarget [
	"For an existing relationship, we need to instantiate if the object we're referring to changed, and either was or is now a proxy. Actually we might get away without if it used to be, but now isn't, but better safe than sorry."

	| wasProxy  |
	originalTarget == newTarget ifTrue: [^false].
	wasProxy := false.
	self notFilteringDeletesDo: [
		originalTarget isGlorpProxy ifTrue: [wasProxy := true. originalTarget getValue].
		newTarget isGlorpProxy ifTrue: [wasProxy := true. newTarget getValue]].
	^wasProxy
]

{ #category : #testing }
UnitOfWork >> isNewObject: anObject [ 
	^self newObjects includes: anObject
]

{ #category : #registering }
UnitOfWork >> isRegistered: anObject [

	^transaction isRegistered: anObject
]

{ #category : #'begin/commit/abort' }
UnitOfWork >> mementoObjects [
	"Warning: Excessive cleverness!!! The mementoObjects we want to iterate over are the values in the correspondenceMap dictionary. We were getting the values and returning them, but if all we need to do is iterate, then the dictionary itself works fine"
	^self correspondenceMap
]

{ #category : #accessing }
UnitOfWork >> newObjects [
	newObjects isNil ifTrue: [newObjects := IdentitySet new].
	^newObjects
]

{ #category : #private }
UnitOfWork >> notFilteringDeletesDo: aBlock [
	"Execute aBlock, with filtering of deletes turned off. This is useful if we are in the process of deleting an object. Suppose we are deleting an object that has a link table relationship, but we have already deleted one of the linked objects. We need to make sure we also delete the link table entry, which means we need to know about that linked object, so we don't want Glorp filtering it out for us."

	| oldCommitPhase |
	[oldCommitPhase := commitPhase.
	commitPhase := #registering.
	aBlock value] ensure: [commitPhase := oldCommitPhase]
]

{ #category : #accessing }
UnitOfWork >> numberOfRows [
	^commitPlan size + deletePlan size
]

{ #category : #'private/mapping' }
UnitOfWork >> originalValueFor: anObject mapping: eachMapping [
	| memento |
	memento := transaction undoMap at: anObject.
	^eachMapping getValueFrom: memento
]

{ #category : #'begin/commit/abort' }
UnitOfWork >> postCommit [
	self sendPostWriteNotification.
	self updateSessionCache.
	self validateRowsPostWrite.
]

{ #category : #'begin/commit/abort' }
UnitOfWork >> preCommit [
	commitPhase := #registering.
	self registerTransitiveClosure.
	commitPhase := #building.
	self createRows.
	linkRowsForUpdate := rowMap collapseMatchingInsertsAndDeletes.
	self buildCommitPlan.
	commitPhase := nil.
	self sendPreWriteNotification.
	self validateRows
]

{ #category : #private }
UnitOfWork >> privateGetRowMap [

	^rowMap
]

{ #category : #private }
UnitOfWork >> privateGetTransaction [

	^transaction
]

{ #category : #'begin/commit/abort' }
UnitOfWork >> propagateDeletes [
	"If we have objects which are to be deleted, and they have exclusive relationships to other objects, then we must also delete those other objects."
	| deletionQueue |
	deletionQueue := OrderedCollection new: deletedObjects size.
	deletionQueue addAll: deletedObjects.
	[deletionQueue isEmpty]
		whileFalse:
			[| each |
			each := deletionQueue removeFirst.
			(self session descriptorFor: each) mappings
				do:
					[:eachMapping | 
					eachMapping isExclusive
						ifTrue:
							[eachMapping
								loopOverAttributeOf: each
								doing:
									[:index :subObject | 
									| realSubObject |
									realSubObject := subObject yourSelf.
									(realSubObject notNil and: [(deletedObjects includes: realSubObject) not])
										ifTrue:
											[session delete: subObject.
											deletionQueue add: realSubObject]]]]]
]

{ #category : #'private/mapping' }
UnitOfWork >> readBackNewRowInformation [
	| changedObjects |
	changedObjects := rowMap objects.
	changedObjects
		do: 
			[:each | 
			| descriptor |
			descriptor := session descriptorFor: each.
			descriptor isNil ifFalse: [descriptor readBackNewRowInformationFor: each in: rowMap]]
]

{ #category : #registering }
UnitOfWork >> register: anObject [ 

	| realObject |
	commitPhase == #building ifTrue: [self halt]. "Should not happen. Probably indicates that we're triggering proxies while firing the mappings"
	realObject := transaction register: anObject.
	self registerTransitiveClosureFrom: realObject
]

{ #category : #private }
UnitOfWork >> registerAsNew: anObject [ 
	anObject isNil ifTrue: [^nil].
	commitPhase == #building ifTrue: [self halt]. "Should not happen. Probably indicates that we're triggering proxies while firing the mappings"
	self newObjects add: anObject.
	self register: anObject.
	^anObject
]

{ #category : #registering }
UnitOfWork >> registerForDelete: anObject [ 
	"Register anObject with intent to delete it."
	[deleting add: anObject.
	self register: anObject] ensure: [deleting remove: anObject ifAbsent: []]
]

{ #category : #'begin/commit/abort' }
UnitOfWork >> registerTransitiveClosure [
	"Look for new objects reachable from currently registered objects, and propagate deletions"

	self computeCollectionDeletes.
	self
		registeredObjectsDo:
			[:eachObject | self registerTransitiveClosureFrom: eachObject].
	self propagateDeletes.
]

{ #category : #'private/mapping' }
UnitOfWork >> registerTransitiveClosureFrom: anObject [

	| descriptor |
	anObject glorpIsCollection ifTrue: [
		anObject do: [:each | session register: each].
		^self].

	descriptor := session descriptorFor: anObject class.
	descriptor isNil ifTrue: [^self].
	descriptor mappings do: [:eachMapping |
			self instantiateIfRequiredFor: anObject mapping: eachMapping].
	descriptor referencedIndependentObjectsFrom: anObject do: [:eachObject |
		session register: eachObject]
]

{ #category : #'begin/commit/abort' }
UnitOfWork >> registeredObjects [
	^self correspondenceMap keys asOrderedCollection
]

{ #category : #enumerating }
UnitOfWork >> registeredObjectsDo: aBlock [

	transaction registeredObjectsDo: [:each |
		(each glorpIsCollection or: [session hasDescriptorFor: each]) ifTrue: [
			aBlock value: each]]
]

{ #category : #initialization }
UnitOfWork >> reinitialize [

	rowMap := RowMap new.
	commitPhase := nil.
	deletedObjects := IdentitySet new.
	deleting := IdentitySet new.
	commitPlan := OrderedCollection new.
	deletePlan := OrderedCollection new.
	transaction abort
]

{ #category : #'private/mapping' }
UnitOfWork >> relatedRowsFor: each [
	| rows extraRows |
	rows := each relatedRowsIn: rowMap.
	extraRows := self session system additionalRelatedRowsFor: each in: rowMap.
	extraRows isNil ifFalse: [rows addAll: extraRows].
	^rows select: [:eachRelatedRow | eachRelatedRow status notNil]
]

{ #category : #'private/mapping' }
UnitOfWork >> reserveSequenceNumbers [
	rowsByTable := commitPlan glorpGroupedBy: [:each | each table].
	rowsByTable keysAndValuesDo: [:eachTable :rows | 
		eachTable sequences do: [:eachSequence | 
			eachSequence 
				reserveSequenceNumbers: (
					rows inject: 0 into: [:sum :each | 
						(each needsValueFromSequence: eachSequence) 
							ifTrue: [sum + 1] ifFalse: [sum]])
					in: self session
					for: eachTable]]
]

{ #category : #'begin/commit/abort' }
UnitOfWork >> rollback [
	self abort.
]

{ #category : #enumerating }
UnitOfWork >> rowsForTable: aTable do: aBlock [

	rowMap rowsForTable: aTable do: aBlock
]

{ #category : #accessing }
UnitOfWork >> rowsToWrite [
	^commitPlan
]

{ #category : #private }
UnitOfWork >> sendPostWriteNotification [
	self 
		registeredObjectsDo: [:eachObject | session sendPostWriteEventTo: eachObject]
]

{ #category : #private }
UnitOfWork >> sendPreWriteNotification [
	self 
		registeredObjectsDo: [:eachObject | session sendPreWriteEventTo: eachObject]
]

{ #category : #accessing }
UnitOfWork >> session [
	^session
]

{ #category : #accessing }
UnitOfWork >> session: aGlorpSession [
	session := aGlorpSession
]

{ #category : #testing }
UnitOfWork >> shouldFilterDeletions [
	"Should we filter deleted objects from the results of queries. We don't do this if we're in the process of registering the transitive closure, because any fetches we do there are in order to get information we need for the commit (e.g. primary keys). If we filtered the deleted objects, then we may not be able to figure out primary keys for the objects to be deleted"
	^commitPhase ~~ #registering
]

{ #category : #'private/mapping' }
UnitOfWork >> sortCommitPlanRows [
	| sorter |
	sorter := GlorpRowSorter new
		getChildrenVia: [:each | self relatedRowsFor: each].
	commitPlan := sorter sort: commitPlan.
	sorter := GlorpRowSorter new
		getChildrenVia: [:each | self relatedRowsFor: each].
	deletePlan := sorter sort: deletePlan
]

{ #category : #accessing }
UnitOfWork >> system [
	^session system
]

{ #category : #deletion }
UnitOfWork >> undelete: anObject ifNotDeleted: aBlock [
	deletedObjects remove: anObject ifAbsent: aBlock.
	(session embeddedObjectsFor: anObject) do: [:each | self undelete: each]
]

{ #category : #'private/mapping' }
UnitOfWork >> updateSessionCache [
	rowMap
		keysAndValuesDo: [:eachObject :eachRow | 
			eachRow shouldBeWritten ifTrue: [
				self updateSessionCacheFor: eachObject withRow: eachRow]].
	deletedObjects do: [:each |
		session cacheRemoveObject: each].
	linkRowsForUpdate do: [:eachRow |
		eachRow shouldBeWritten ifTrue: [
			self updateSessionCacheFor: eachRow owner withRow: eachRow]].
]

{ #category : #'private/mapping' }
UnitOfWork >> updateSessionCacheFor: anObject withRow: aRow [ 
	| key |
	(rowMap isRowMapKey: anObject) ifTrue: [^self].  "Not cachable"
	key := aRow primaryKey.
	key isNil ifTrue: [^self].
	(session cacheContainsObjectForClass: anObject class key: key) 
		ifFalse: [self addObject: anObject toCacheKeyedBy: key]
]

{ #category : #'begin/commit/abort' }
UnitOfWork >> validateRows [
	"Perform basic validation. Always test for equal named but non-identical tables, a sign of a malformed  system or other loss of identity. Also delegate to the descriptorSystem, which may have useful application-specific validations to do."
	
	| tables tableNames |
	tables := Set new.
	rowMap rowsDo: [:each |
		tables add: each table].
	tableNames := tables collect: [:each | each qualifiedName].
	tables asSet size = tableNames asSet size ifFalse: [self error: 'multiple table objects with the same name'].
	self system validateRows: self
]

{ #category : #'begin/commit/abort' }
UnitOfWork >> validateRowsPostWrite [
	"Perform basic validation after writing is done. It's better to validate beforehand, but some things are easier to catch afterwards"
	
	self system validateRowsPostWrite: self.
]

{ #category : #deletion }
UnitOfWork >> willDelete: anObject [
	"Return true if we will delete anObject when we commit."	
	^(deletedObjects includes: anObject) or: [deleting includes: anObject]
]

{ #category : #'private/mapping' }
UnitOfWork >> writeRows [

	succeeded := true.
	self reserveSequenceNumbers.
	self assignSequenceNumbers.
	self session tablesInCommitOrder do: [:eachTable | self writeRowsForTable: eachTable].
	deletePlan reverseDo: [:eachRow | | rowSucceeded |
		rowSucceeded := session writeRow: eachRow.
		succeeded := succeeded & rowSucceeded].
	self readBackNewRowInformation
]

{ #category : #'private/mapping' }
UnitOfWork >> writeRowsForTable: aTable [

	| rows rowsByOperation |

	rows := rowsByTable at: aTable ifAbsent: [#()].
	^rows isEmpty ifFalse: [
		rowsByOperation := rows glorpGroupedBy: [:eachRow | session shouldInsert: eachRow].
		rowsByOperation do: [:eachListOfHomogeneousRows | 
			succeeded := succeeded & (session writeHomogeneousRows: eachListOfHomogeneousRows)]]
]
