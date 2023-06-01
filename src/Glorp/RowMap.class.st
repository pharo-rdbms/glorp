"
This is the central class used for writing. We build up a collection of rows that are to be written, indexed by the objects that ""own"" them. While any object can contribute values to a row (for example, in a relationship, the value of a field that is a foreign key may come from the primary key of another object) it is a central assumption that each row is owned by a single object. Once we know all the rows, we can compute which ones have changed from their previous database values (see RowMapForMementos) and which fields within them have changed, and then we can write them out.

Instance Variables:
	hasDeletions	<Boolean>	Do we have any deletions. Deletions are marked by a flag in the row, but it's useful to know quickly if we have any or not.
	rowDictionary	<(Dictionary from: DatabaseTable to: (Dictionary from: Object to: DatabaseRow)>	The rows, indexed by their table, then by the owning object.


"
Class {
	#name : #RowMap,
	#superclass : #Object,
	#instVars : [
		'rowDictionary',
		'hasDeletions'
	],
	#category : #'Glorp-UnitOfWork'
}

{ #category : #'instance creation' }
RowMap class >> forRows: aCollection [
	"Convenience - construct a row map from a given set of rows"
	| map |
	map := self new.
	aCollection do: [:each | map addRow: each].
	^map
]

{ #category : #'instance creation' }
RowMap class >> new [

	^super new initialize
]

{ #category : #'instance creation' }
RowMap class >> new: size [

	^super new initialize: size
]

{ #category : #lookup }
RowMap >> addRow: aRow [
	^self addRow: aRow forTable: aRow table withKey: aRow owner
]

{ #category : #lookup }
RowMap >> addRow: aRow forTable: aTable withKey: aKey [ 
	| submap |
	aKey isGlorpProxy ifTrue: [self halt].
	submap := self subMapForTable: aTable withKey: aKey.
	submap at: aKey put: aRow.
	^aRow
]

{ #category : #'set operations' }
RowMap >> additiveDifferencesFrom: aRowMap into: differencesMap [
	"Add everything which is in us, but not in aRowMap into differencesMap"
	| newRow |
	self objectsAndRowsDo: [:object :row |
		| correspondingRow |
		correspondingRow := aRowMap
			rowForTable: row table
			withKey: object
			ifAbsent: [DatabaseRow new].
		(row equals: correspondingRow)
			ifFalse:
				[newRow := differencesMap
					addRow: (row withAllFieldsIn: correspondingRow)
					forTable: row table
					withKey: object.
				newRow forDeletion: row forDeletion]]
]

{ #category : #'private/mapping' }
RowMap >> adjustForMementos: objects [
	^self
]

{ #category : #api }
RowMap >> at: aField key: anObject put: aValue [
	(self findOrAddRowForTable: aField table withKey: anObject) at: aField put: aValue
]

{ #category : #'private/deletion' }
RowMap >> collapseMatchingInsertsAndDeletes [
	^rowDictionary
		inject: Dialect identitySetClass new
		into:
			[:sum :eachTablesRowList | 
			sum addAll: (self collapseMatchingInsertsAndDeletesFor: eachTablesRowList).
			sum]
]

{ #category : #'private/deletion' }
RowMap >> collapseMatchingInsertsAndDeletesFor: eachTablesRows [
	"Find any inserts and deletes for these rows which have the same primary key. We expect these to be link table rows, because for rows that map to objects, Glorp-managed object identity should ensure this never happens (i.e. it can happen if, but only if, a user explicitly deletes an object and adds another, giving it the same key, in the same transaction). Force the insert to be an update instead (by returning it to the calling method, which will force that to happen) and remove the deletion."

	| deletions updates matchedDeletions deletion |
	(self isSuitableForCollapsing: eachTablesRows) ifFalse: [^#()].
	deletions := Dictionary new: 50.
	updates := OrderedCollection new.
	eachTablesRows do: [:each | each forDeletion ifTrue: [
		deletions at: (each primaryKey) put: each]].
	deletions isEmpty ifTrue: [^#()].
	matchedDeletions := IdentitySet new: deletions size.

	eachTablesRows do:
		[:each || pk |
		pk := each primaryKey.
		((deletions includesKey: pk) and: [each forDeletion not]) ifTrue:
			[deletion := deletions at: pk.
			(matchedDeletions includes: deletion) ifFalse:
				["If we could trust the user always to delete the right object, or one with no field values accidentally matching a changed new row value, then we could do
				each withAllFieldsIn: deletion. 
then add
				each fieldsNeedingUpdate isEmpty or:
to the no-op check following.  Lacking this certainty, we do not set the deletion row to be the oldVersion of the each row, thus ensuring the update command will update all the non-primaryKey fields whether they differ between deletion and each or not."
				"Now here's a very special case. If there are no non-primary key fields, then we collapse this down to a no-op. We've deleted and re-inserted with exactly the same information. However, we still leave it in the list of updated rows, because we want it to be put into the session cache if it's not already there at the end."
				each table primaryKeyFields size = each fields size
					ifTrue: [self privateDeleteRow: each].
				"Make the row an update, with the deletion as its old value."
				updates add: each.
				matchedDeletions add: deletion.
				self privateDeleteRow: deletion]]].
	^updates
]

{ #category : #'private/mapping' }
RowMap >> collectionMementoFor: aCollection [

	^aCollection
]

{ #category : #'private/deletion' }
RowMap >> compress [
	"Remove all deleted rows and rebuild"
	| newDictionary |
	hasDeletions ifFalse: [^self].
	hasDeletions := false.
	newDictionary := IdentityDictionary new: rowDictionary size.
	rowDictionary keysAndValuesDo: [:eachTable :eachRowDict |
		| newRowDict |
		newRowDict := IdentityDictionary new: eachRowDict size.
		eachRowDict keysAndValuesDo: [:eachObject :eachRow |
			(self isDeleted: eachRow) ifFalse: [
				newRowDict at: eachObject put: eachRow]].
		newDictionary at: eachTable put: newRowDict].
	rowDictionary := newDictionary.
]

{ #category : #lookup }
RowMap >> deleteRowForTable: aTable withKey: aKey ifAbsent: aBlock [
	"Don't actually delete, the fixup of the hash tables is too expensive. Mark invisible instead, overloading the status variable that we know we're not using until later"

	| row |
	row := (self subMapForTable: aTable) at: aKey ifAbsent: aBlock.
	row isNil ifFalse: [self privateDeleteRow: row]
]

{ #category : #'private/mapping' }
RowMap >> dictionaryClassRequiredForKey: anObject [

	^(self isRowMapKey: anObject)
		ifTrue: [Dictionary]
		ifFalse: [IdentityDictionary]
]

{ #category : #'set operations' }
RowMap >> differenceFrom: aMementoRowMap [
	| differencesMap |
	differencesMap := RowMap new.
	self	additiveDifferencesFrom: aMementoRowMap into: differencesMap.
	self	subtractiveDifferencesFrom: aMementoRowMap into: differencesMap.
	^differencesMap
]

{ #category : #api }
RowMap >> findOrAddRowForTable: aTable withKey: aKey [
	| submap row |
	submap := self subMapForTable: aTable withKey: aKey.
	row := submap
		at: aKey
		ifAbsentPut: [DatabaseRow newForTable: aTable withOwner: aKey].
	^(self isDeleted: row)
		ifTrue:
			[| newRow |
			newRow := DatabaseRow newForTable: aTable withOwner: aKey.
			submap at: aKey put: newRow.
			newRow]
		ifFalse: [row]
]

{ #category : #lookup }
RowMap >> includesRowForTable: aTable withKey: aKey [

	| row |
	row := (self subMapForTable: aTable ifAbsent: [^false]) at: aKey ifAbsent: [^false].
	^(self isDeleted: row) not
]

{ #category : #'initialize-release' }
RowMap >> initialize [
      self initialize: 17
]

{ #category : #'initialize-release' }
RowMap >> initialize: size [
	rowDictionary := IdentityDictionary new: size.
	hasDeletions := false
]

{ #category : #'private/deletion' }
RowMap >> isDeleted: row [
	^row status == #invisible
]

{ #category : #testing }
RowMap >> isEmpty [
	self compress.
	self rowsDo: [:each | (self isDeleted: each) ifFalse: [^false]].
	^true.
]

{ #category : #api }
RowMap >> isRowMapKey: anObject [
	^anObject class == RowMapKey or: [anObject class == MultipleRowMapKey]
]

{ #category : #'private/deletion' }
RowMap >> isSuitableForCollapsing: eachTablesRows [
	"Return true if this set of rows are suitable for collapsing the inserts and deletes together. It's suitable if this is a link table, and if there is a primary key defined which we can use to decide if the rows match or not"
	eachTablesRows isEmpty ifTrue: [^false].
	eachTablesRows
		keysAndValuesDo:
			[:eachKey :eachRow | 
				"(self isRowMapKey: eachKey) ifFalse: [^false]."
				eachRow table primaryKeyFields isEmpty ifTrue: [^false].
				^true ]
]

{ #category : #iterating }
RowMap >> keysAndValuesDo: aBlock [ 
	self tables do: [:each | 
		(self subMapForTable: each) keysAndValuesDo: aBlock]
]

{ #category : #api }
RowMap >> mementoFor: anObject [
	^anObject
]

{ #category : #testing }
RowMap >> notEmpty [
	^self isEmpty not
]

{ #category : #counting }
RowMap >> numberOfEntries [
	self compress.
	^rowDictionary inject: 0 into: [:sum :each | sum + each size]
]

{ #category : #counting }
RowMap >> numberOfEntriesForTable: aTable [
	self compress.
	^(self subMapForTable: aTable) size
]

{ #category : #iterating }
RowMap >> objects [
	| objects |
	objects := IdentitySet new.
	self tables do: [:each | objects addAll: (self subMapForTable: each) keys].
	^objects
]

{ #category : #iterating }
RowMap >> objectsAndRowsDo: aTwoArgumentBlock [
	rowDictionary
		do:
			[:eachObjectToRowDictionary | 
			eachObjectToRowDictionary
				keysAndValuesDo:
					[:key :value | 
					(self isDeleted: value)
						ifFalse: [aTwoArgumentBlock value: key value: value]]]
]

{ #category : #iterating }
RowMap >> objectsAndRowsForTable: aTable do: aTwoArgumentBlock [
	^(self subMapForTable: aTable)
		keysAndValuesDo:
			[:key :value | 
			(self isDeleted: value)
				ifFalse: [aTwoArgumentBlock value: key value: value]]
]

{ #category : #iterating }
RowMap >> objectsDo: aBlock [
	self tables
		do:
			[:each | 
			(self subMapForTable: each)
				keysAndValuesDo:
					[:key :value | (self isDeleted: value) ifFalse: [aBlock value: key]]]
]

{ #category : #'private/deletion' }
RowMap >> privateDeleteRow: row [
	row status: #invisible.
	hasDeletions := true
]

{ #category : #'private/mapping' }
RowMap >> reverseLookup: anObject [

	^anObject
]

{ #category : #lookup }
RowMap >> rowForTable: aTable withKey: aKey [ 
	^self rowForTable: aTable withKey: aKey ifAbsent: [self error: 'missing element']
]

{ #category : #lookup }
RowMap >> rowForTable: aTable withKey: aKey ifAbsent: aBlock [
	| row |
	row := (self subMapForTable: aTable) at: aKey ifAbsent: aBlock.
	^(self isDeleted: row) ifTrue: [aBlock value] ifFalse: [row]
]

{ #category : #lookup }
RowMap >> rowForTable: aTable withKey: aKey ifPresent: aBlock [
	^(self subMapForTable: aTable)
		at: aKey
		ifPresent:
			[:row | (self isDeleted: row) ifTrue: [nil] ifFalse: [aBlock value: row]]
]

{ #category : #iterating }
RowMap >> rowsDo: aBlock [ 
	self tables do: [:each | self rowsForTable: each do: aBlock]
]

{ #category : #'private/mapping' }
RowMap >> rowsForKey: aKey [
	"Return a collection of all rows for any table which are keyed by aKey"

	| rowsForKey |
	rowsForKey := OrderedCollection new: 5.
	rowDictionary
		do:
			[:each | 
			| row |
			row := each at: aKey ifAbsent: [nil].
			(row notNil and: [(self isDeleted: row) not]) ifTrue: [rowsForKey add: row]].
	^rowsForKey
]

{ #category : #iterating }
RowMap >> rowsForTable: aTable do: aBlock [
	^(self subMapForTable: aTable)
		keysAndValuesDo:
			[:key :value | (self isDeleted: value) ifFalse: [aBlock value: value]]
]

{ #category : #'private/mapping' }
RowMap >> subMapForTable: aTable [
	
	^self subMapForTable: aTable withKey: nil
]

{ #category : #'private/mapping' }
RowMap >> subMapForTable: aTable ifAbsent: aBlock [ 
	^rowDictionary at: aTable ifAbsent: aBlock
]

{ #category : #'private/mapping' }
RowMap >> subMapForTable: aTable withKey: anObject [ 
	anObject isGlorpProxy ifTrue: [self halt].
	^rowDictionary at: aTable
		ifAbsentPut: [(self dictionaryClassRequiredForKey: anObject) new]
]

{ #category : #'set operations' }
RowMap >> subtractiveDifferencesFrom: aRowMap into: differencesMap [
	"Figure out which things are in aRowMap but not in us. These should be flagged as delete rows. Since we have no further use for aRowMap after this, we can compute this destructively by removing everything that's in us"

	self objectsAndRowsDo: [:object :row |
		aRowMap
			deleteRowForTable: row table
			withKey: object
			ifAbsent: []].
	aRowMap
		objectsAndRowsDo:
			[:object :row | 
			| adjustedObject |
			adjustedObject := (aRowMap reverseLookup: object).
			row forDeletion: true.
			differencesMap
				addRow: row
				forTable: row table
				withKey: adjustedObject]
]

{ #category : #'private/mapping' }
RowMap >> tables [

	^rowDictionary keys
]

{ #category : #api }
RowMap >> unifyField: eachSourceField key: sourceObject withField: eachTargetField key: targetObject [
	| sourceRow targetRow |
	sourceRow := self findOrAddRowForTable: eachSourceField table withKey: sourceObject.
	targetRow := self findOrAddRowForTable: eachTargetField table withKey: targetObject.
	sourceRow unifyField: eachSourceField withField: eachTargetField inRow: targetRow
]

{ #category : #api }
RowMap >> unifyField: sourceField key: sourceObject withField: targetField key: targetObject transformationForward: forwardTransformation inverse: inverseTransformation [
	| sourceRow targetRow existingWrapper newWrapper |
	sourceRow := self findOrAddRowForTable: sourceField table withKey: sourceObject.
	targetRow := self findOrAddRowForTable: targetField table withKey: targetObject.
	sourceRow unifyField: sourceField withField: targetField inRow: targetRow.
	existingWrapper := targetRow wrapperAt: targetField.
	(existingWrapper class == TransformingFieldValueWrapper and: [
		existingWrapper forwardTransformation == forwardTransformation and: [
			existingWrapper inverseTransformation == inverseTransformation]])
				ifTrue: [^self].
	newWrapper := (TransformingFieldValueWrapper new)
		innerWrapper: existingWrapper;
		forwardTransformation: forwardTransformation;
		inverseTransformation: inverseTransformation.
	targetRow wrapperAt: targetField put: newWrapper
]
