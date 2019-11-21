"
This is an abstract superclass for relationships between one mapped object and another (or a collection of others).

Instance Variables:
	join	<Join>	The join between our table and the target. Note that if we use a link table, this will be a join between our table and the link table.
	targetTableJoin	<Join>	If we're using a link table, it may be desirable to also join to attributes of the main table. This optional extra join allows that.

	query	<SimpleQuery>	The query that will return the other side of the relationship, given parameters describing our side.
	linkFields	<Collection of: DatabaseField>	When there's a link table, we need to know the other side of the relationship, from link table to target. Usually we can figure it out based on the target table and the foreign key constraints, but sometimes (e.g. if there are multiple relationships to the same table) we need to be told which fields are the ones that connect to this table. Again that's FROM the LINK table TO the TARGET table, not the entry in the link table that we'd connect  to.
	reverseJoin	<Join>	caches the other end of the relationship, as above.
	rowMapKeyConstructorBlock	<BlockClosure>	Usually row map keys are constructed automatically, but it's possible that in weird cases we  might need to construct complicated ones (e.g. if there are 3 things that need to participate instead of just two, as in Store's use of the same link table and the same row to indicate the relationship from package to class and package to metaclass).
	shouldProxy	<Boolean>	Should we proxy or directly construct the referenced object
	shouldUseFilteredRead	<Boolean>	should we use a filtered read.
	usesLinkTable	<Boolean>	Do we use a link table, or is it a direct join to the target.
	isExclusive <Boolean> Is this an exclusive relationship - so that when the parent object is deleted, the child or children will also be deleted.


"
Class {
	#name : #RelationshipMapping,
	#superclass : #Mapping,
	#instVars : [
		'query',
		'join',
		'usesLinkTable',
		'shouldProxy',
		'linkTableJoin',
		'targetTableJoin',
		'reverseJoin',
		'shouldUseFilteredRead',
		'rowMapKeyConstructorBlock',
		'controlsTables',
		'isExclusive',
		'linkFields',
		'proxyAction'
	],
	#category : 'Glorp-Mappings'
}

{ #category : #mapping }
RelationshipMapping >> addPhantomMappingExpressionOn: base [ 
	| phantomMapping phantomMappingName phantomExpression |
	phantomMapping := self reverseMapping.
	phantomMappingName := 'glorp_internal_' , self attributeName , '_to_' 
				, self descriptor describedClass name.
	phantomExpression := base getMapping: phantomMapping
				named: phantomMappingName.
	phantomExpression bePhantom.
	^phantomExpression
]

{ #category : #accessing }
RelationshipMapping >> allTables [

	(self join) isNil ifTrue: [^#()].
	^(self join) allTables.
]

{ #category : #accessing }
RelationshipMapping >> basicReferenceClass [
	^self attribute type.
]

{ #category : #accessing }
RelationshipMapping >> basicReferenceDescriptor [
	^self system descriptorFor: self basicReferenceClass.
]

{ #category : #api }
RelationshipMapping >> beExclusive [
	"Make this an exclusive relationship - so that when the parent object is deleted, the child or children will also be deleted"
	isExclusive := true.
]

{ #category : #mapping }
RelationshipMapping >> buildGeneralQueryIn: anObjectBuilder [
	"For filtered queries. We need to build this in terms of the parent query"

	| base parentCriteria fullCriteria phantomExpression newQuery |
	base := BaseExpression new.
	base descriptor: self referenceDescriptor.
	phantomExpression := self addPhantomMappingExpressionOn: base.
	parentCriteria := anObjectBuilder query whereClause.
	fullCriteria := parentCriteria
		rebuildOn: phantomExpression.
	newQuery := Query read: self referenceClass.
	"newQuery collectionType: self collectionType."
	fullCriteria isEmptyExpression ifFalse: [newQuery where: fullCriteria].
	self
		setGeneralQueryRetrievalIn: newQuery
		basedOn: base
		phantom: phantomExpression.
	^newQuery.
]

{ #category : #mapping }
RelationshipMapping >> buildQuery [
	| toMany |
	toMany := self attribute isCollectionAttribute.
	query := toMany
		ifTrue: [Query read: self referenceClass where: self join]
		ifFalse: [Query readOneOf: self referenceClass where: self join].
	query session: self session.
	query baseExpression descriptor: (self session descriptorFor: self referenceClass).
	query collectionType: self collectionType.
	self usesLinkTable ifTrue: [
		query AND: (self expressionFromLinkToReferenceTableWithBase: query baseExpression)].
	^query.
]

{ #category : #mapping }
RelationshipMapping >> buildRowMapKeyForSource: source target: target index: index [
	^(RowMapKey new)
		key1: target yourSelf;
		key2: source yourSelf.
]

{ #category : #accessing }
RelationshipMapping >> collectionType [
	^nil.
]

{ #category : #'private/expressions' }
RelationshipMapping >> constraints [
	"Return a list of the constraints from our link table. If the linkField is set, filter the constraints to those that include that field. "
	| referenceKeys linkTable referenceTables allConstraints relevantConstraints |
	referenceKeys := (self join) targetKeys asOrderedCollection.
	linkTable := referenceKeys first table.
	"If we haven't been told the relevant link table fields, assume we can find them by looking at all the ones that aren't the ones from our source to the link, and all the rest will be from the link to the target"
	allConstraints := linkTable foreignKeyConstraints.
	relevantConstraints := linkFields isNil 
		ifTrue: [allConstraints reject: [:each |  each sourceFields allSatisfy: [:eachSourceField |
			(referenceKeys includes: eachSourceField)]]]
		ifFalse: [allConstraints select: [:each | each sourceFields anySatisfy: [:eachSourceField |
			linkFields includes: eachSourceField]]].

	"Validate that we can handle this case"
	referenceTables := (relevantConstraints collect: [:each | each targetTable]) asSet.
	referenceTables size > 1 ifTrue: [self error: 'Cannot handle this general a case. Try hinting using relevantLinkTableFields:'].
	referenceTables size = 0 ifTrue: [self error: 'No tables found. Did you set up foreign key references in the table definitions?'].

	^relevantConstraints.
]

{ #category : #initializing }
RelationshipMapping >> constraintsFrom: oneTableSet to: anotherTableSet [
	^(self oneWayConstraintsFrom: oneTableSet to: anotherTableSet), 
		(self oneWayConstraintsFrom: anotherTableSet to: oneTableSet)
]

{ #category : #api }
RelationshipMapping >> constructRowMapKeyAs: aBlock [
	"Give us the opportunity to construct a custom row map key. This is useful if you need to force two relationships to share a link table entry"
	rowMapKeyConstructorBlock := aBlock.
]

{ #category : #testing }
RelationshipMapping >> controlsTables [
	"Return true if this type of method 'owns' the tables it's associated with, and expression nodes using this mapping should alias those tables where necessary"

	^controlsTables
]

{ #category : #accessing }
RelationshipMapping >> controlsTables: aBoolean [
	"We can indicate that this relationship does not actually control its tables. This is going to be true if the parent controls the same tables and coexists with us. Think StoreVersionlessPundle and Pundle"
	controlsTables := aBoolean.
]

{ #category : #mapping }
RelationshipMapping >> createDeleteRowFor: anObject in: aRowMap [
	"This is like firing the mapping, but instead of creating the data, we just need to check if there are link table entries, and if so, make sure they are deleted"
	| target mementoizedTarget|
	self canWrite ifFalse: [^self].
	self usesLinkTable ifFalse: [^self].
	target := self getValueFrom: anObject.
	target := self session realObjectFor: target ifNone: [^self].
	(self isValidTarget: target) ifTrue: [
		mementoizedTarget := aRowMap collectionMementoFor: target.
		self createDeleteRowForLinkFrom: anObject toTarget: mementoizedTarget in: aRowMap].
]

{ #category : #mapping }
RelationshipMapping >> createDeleteRowForLinkFrom: anObject toTarget: target in: aRowMap [
	| linkTable |
	self usesLinkTable ifFalse: [^false].
	linkTable := self linkTableJoin allTables asArray first.
	self attribute
		loopOver: target
		doing:
			[:index :eachTarget | 
			| intermediate |
			intermediate := self
				rowMapKeyForSource: anObject
				target: eachTarget
				index: index.
			aRowMap
				rowForTable: linkTable
				withKey: intermediate
				ifPresent:
					[:linkRow | linkRow isEmpty ifFalse: [linkRow forDeletion: true]]].
]

{ #category : #'private/expressions' }
RelationshipMapping >> expressionFromLinkToReferenceTableWithBase: base [

	| reverse |
	reverse := self reverseJoin asGlorpExpressionOn: base.
	^reverse asGeneralGlorpExpressionWithFields.
]

{ #category : #mapping }
RelationshipMapping >> extendedJoin [
	"In order to do a many-to-many read we need more information than just the write, we need to know 
	the relationship to the other table. Construct that based on the table information"

	| generalMappingCriteria base |
	self usesLinkTable ifFalse: [^self join].
	generalMappingCriteria := self join asGeneralGlorpExpressionWithFields.
	base := generalMappingCriteria ultimateBaseExpression.
	^(self expressionFromLinkToReferenceTableWithBase: base) AND: generalMappingCriteria.
]

{ #category : #mapping }
RelationshipMapping >> extendedJoinFromSource: sourceExpression toTarget: targetExpression [
	"In order to do a many-to-many read we need more information than just the write, we need to know 
	the relationship to the other table. Construct that based on the table information"

	| generalMappingCriteria |
	self usesLinkTable 
		ifFalse: [^self join asExpressionJoiningSource: sourceExpression toTarget: targetExpression].

	generalMappingCriteria := self join asExpressionJoiningSource: sourceExpression toTarget: targetExpression.
	^(self expressionFromLinkToReferenceTableWithBase: targetExpression) AND: generalMappingCriteria.
]

{ #category : #printing }
RelationshipMapping >> field [
	^self join targetKeys first
]

{ #category : #testing }
RelationshipMapping >> hasValueThatCanProvideField: aField from: anObject [
	"Return true if we have enough information in ourselves to populate our fields. The only time this won't be true is if we're either holding an uninstantiated proxy or have a to-many relationship mapping with an empty collection. Assumes that aField is one that we map."
	| value |
	value := self getValueFrom: anObject.
	value isGlorpProxy ifFalse: [^value notNil].
	value isInstantiated ifTrue: [^true].
	^value parameters includesKey: aField.
]

{ #category : #initializing }
RelationshipMapping >> initialize [

	super initialize.
	shouldProxy := true.
	shouldUseFilteredRead := false.
	usesLinkTable := false.
	controlsTables := true.
	isExclusive := false.
]

{ #category : #initializing }
RelationshipMapping >> initializeJoin [
	"We haven't been given a join. There might be a compound one, or else see if we can make an educated guess at one"
	linkTableJoin notNil ifTrue: [join := linkTableJoin, targetTableJoin. ^self].
	self initializeJoinTo: self relatedTables.
]

{ #category : #initializing }
RelationshipMapping >> initializeJoinTo: otherTables [
	"We haven't been giving a join. See if we can make an educated guess at one by looking for tables with constraints to us. If linkFields is set, it tells us the source field for the relationship between the link table and the target, so in looking for our own relationship to the link table, we exclude that."
	| toConstraints fromConstraints |
	self descriptor tables isEmpty ifTrue: [^self join: Join new].
	(self referenceDescriptor tables isEmpty and: [self referenceDescriptor typeResolver usesInheritance]) ifTrue: [^self join: Join new].
	toConstraints := self oneWayConstraintsFrom: self descriptor tables to: otherTables.
	linkFields isNil ifFalse: [toConstraints := toConstraints reject: [:eachConstraint | eachConstraint targetFields anySatisfy: [:eachField | linkFields includes: eachField]]].
	fromConstraints :=  self oneWayConstraintsFrom: otherTables to: self descriptor tables.
	linkFields isNil ifFalse: [fromConstraints := fromConstraints reject: [:eachConstraint | eachConstraint sourceFields anySatisfy: [:eachField | linkFields includes: eachField]]].

	self join: (self system joinFor: self toTables: otherTables fromConstraints: fromConstraints toConstraints: toConstraints).
]

{ #category : #api }
RelationshipMapping >> isExclusive [
	"Return whether this an exclusive relationship - so that when the parent object is deleted, the child or children will also be deleted"
	^isExclusive.
]

{ #category : #api }
RelationshipMapping >> isExclusive: aBoolean [
	"Set whether this an exclusive relationship - so that when the parent object is deleted, the child or children will also be deleted"
	isExclusive := aBoolean.
]

{ #category : #testing }
RelationshipMapping >> isRelationship [
	"True when the mapping associates different persistent classes."

	^true
]

{ #category : #testing }
RelationshipMapping >> isStoredInSameTable [
	"Normally, a relationship mapping isn't stored in the same table, but if we're part of a dictionary mapping and the table is mapped to an association, then we want to be treated that way. The test is a horrible hack"
	^self classModel describedClass == Association.
]

{ #category : #testing }
RelationshipMapping >> isToManyRelationship [
	^self attribute isCollectionAttribute.
]

{ #category : #mapping }
RelationshipMapping >> isValidTarget: anObject [

	^anObject isGlorpProxy
		ifTrue: [anObject isInstantiated]
		ifFalse: [true].
]

{ #category : #accessing }
RelationshipMapping >> join [
	join isNil ifTrue: [self initializeJoin].
	^join.
]

{ #category : #accessing }
RelationshipMapping >> join: aJoin [
	"We allow the join to be specified either as a Join (the normal case) or as an expression. We expect an expression specifying the relationship in terms of other relationships. So, e.g. to specify the join from InsurancePlan to PolicyHolder we might specify
[:eachPolicyHolder | eachPolicyHolder employer availablePlans].  Note that the relationship is described from the point of view of the target, and is just a list of mappings. Then we take this internally and transform it into an equality expression we can use to define the relationship."
	| base basicExpression |
	(Dialect isBlock: aJoin) 
		ifTrue: [
			self beReadOnly.
			base := JoinBaseExpression new.
			base descriptor: (self system descriptorFor: self referenceClass).
			basicExpression := aJoin asGlorpExpressionOn: base.
			"It doesn't matter what name we give the parameter, because it will be rewritten into a primary key comparison anyway, that will use the fields as 'names'. Also, it's important that we assign into join here, because otherwise the rewriteEquality operation will try and figure out a join for us, since it's still nil."
			join := basicExpression get: #= withArguments: (
				Array with: (ParameterExpression forField: 'sourceObject' basedOn: basicExpression join)).
			join := join rewriteEquality]
		ifFalse: [join := aJoin].
	[join owningMapping: self] on: MessageNotUnderstood do: [:ex | ex | ex return].
]

{ #category : #preparing }
RelationshipMapping >> joinExpressionFor: targetExpression [
	"We're looking for the object represented by this mapping, and we know the object represented by its source. Use our mapping criteria to construct a join that traverses that instance of this relationship"

	| sourceExpression |
	(self controlsTables not and: [self classModel describedClass == Association]) ifTrue: [^nil].
	sourceExpression := targetExpression base.
	^self extendedJoinFromSource: sourceExpression toTarget: targetExpression.
]

{ #category : #'private/expressions' }
RelationshipMapping >> joinFromLinkToReferenceTable [
	"Generate the inverse mapping expression, i.e. the one connecting the link table to the reference table, using the foreign key constraints. We assume that if there's a general part, it applies only to the original join, and not to the reverse join that we're generating."

	| expression generalPart |
	expression := Join new.
	self constraints do: [:eachConstraint | 
		eachConstraint sourceFields with: eachConstraint targetFields do: 
			[:eachSource :eachTarget |
				expression addSource: eachSource target: eachTarget]].
	generalPart := self join generalExpressionPart.
	^generalPart isNil ifTrue: [expression] ifFalse: [generalPart AND: expression].
]

{ #category : #mapping }
RelationshipMapping >> knitFromBuilder: sourceBuilder toBuilder: targetBuilder [ 
	self canRead ifFalse: [^self].
	self attribute knit: sourceBuilder instance to: targetBuilder instance
]

{ #category : #api }
RelationshipMapping >> linkField: aDatabaseField [
	linkFields := Array with: aDatabaseField.
]

{ #category : #api }
RelationshipMapping >> linkFields [
	^linkFields.
]

{ #category : #api }
RelationshipMapping >> linkFields: aCollection [
	"Set the fields that are foreign keys *from* the link table (this is only used if we have one) to the *target* table. This is used as a hint in the case where the link table is ambiguous, and is easier than specifying the full join."
	linkFields := aCollection.
]

{ #category : #accessing }
RelationshipMapping >> linkTableJoin [
	linkTableJoin isNil ifTrue: [^self join].
	^linkTableJoin
]

{ #category : #accessing }
RelationshipMapping >> linkTableJoin: aJoin [
	"Set the join from the link table to the target table. Normally this is calculated automatically (see reverseJoin), but it can be set manually if that's not possible (for example, because you want to include a constant value in the join, that won't be included in the foreign key constraints). See also relevantLinkTableFields if you need to give a hint."
	linkTableJoin := aJoin.
	[aJoin owningMapping: self] on: MessageNotUnderstood do: [:ex | ex | ex return].
]

{ #category : #mapping }
RelationshipMapping >> mapFromObject: anObject intoRowsIn: aRowMap [ 
	"Our target is a collection. The tricky bit is that if we're building rows into a RowMapForMementos, then the collection we contain isn't the one we want to use. We want the old version. Ask the row map to give it to us. If it's a normal row map, we'll just get the same thing back" 
	| target mementoizedTarget|
	self canWrite ifFalse: [^self].
	target := self getValueFrom: anObject.
	target := self session realObjectFor: target ifNone: [^self].
	(self isValidTarget: target) ifTrue: [
		mementoizedTarget := aRowMap collectionMementoFor: target.
		self mapFromObject: anObject toTarget: mementoizedTarget puttingRowsIn: aRowMap].
]

{ #category : #mapping }
RelationshipMapping >> mapFromObject: anObject toTarget: target puttingRowsIn: aRowMap [
	self attribute
		loopOver: target
		doing:
			[:index :eachTarget | 
			| intermediate |
			intermediate := self
				rowMapKeyForSource: anObject
				target: eachTarget
				index: index.
			self
				mapOneFromObject: anObject
				toTarget: eachTarget
				intermediate: intermediate
				atPosition: index
				puttingRowsIn: aRowMap].
]

{ #category : #mapping }
RelationshipMapping >> mapObject: anObject inElementBuilder: anElementBuilder [
	| value session parameters |
	session := descriptor session.
	parameters := self parametersIn: anElementBuilder.
	value := self shouldProxy
		ifTrue:
			[| proxy |
			proxy := (self newProxyIn: anElementBuilder)
				session: session;
				parameters: parameters;
				glorpOwner: anObject.
			"If we know in advance the proxy would return nil, or an empty collection, just put that in rather than the proxy"
			(proxy query shortCircuitEmptyReturn: parameters)
				ifTrue: [proxy getValue]
				ifFalse: [proxy]]
		ifFalse:
			[(self queryFor: anElementBuilder)
				executeWithParameters: parameters
				in: session].
	self setValueIn: anObject to: value.
]

{ #category : #mapping }
RelationshipMapping >> mapOneFromObject: sourceObject toTarget: targetObject intermediate: aRowMapKey atPosition: index puttingRowsIn: aRowMap [
	self linkTableJoin
		mapFromSource: sourceObject
		andTarget: aRowMapKey
		intoRowsIn: aRowMap.
	self targetTableJoin isNil
		ifFalse:
			[self targetTableJoin
				mapFromSource: sourceObject
				andTarget: (self mapsSimpleObject ifTrue: [aRowMapKey] ifFalse: [targetObject])
				intoRowsIn: aRowMap].
	self usesLinkTable
		ifTrue:
			[self reverseJoin
				mapFromSource: aRowMapKey
				andTarget: (self mapsSimpleObject ifTrue: [aRowMapKey] ifFalse: [targetObject])
				intoRowsIn: aRowMap].
	self
		writeExtraInformationInto: aRowMap
		atKey: aRowMapKey
		forSourceObject: sourceObject
		targetObject: targetObject
		atIndex: index.
]

{ #category : #testing }
RelationshipMapping >> mappedFields [
	"Return a collection of fields that this mapping will write into any of the containing object's rows"

	^self join allSourceFields select: [:each | each isMappable and: [(each isGlorpExpression not or: [each isConstantExpression not])]].
]

{ #category : #accessing }
RelationshipMapping >> mappingCriteria [
	^self join.
]

{ #category : #accessing }
RelationshipMapping >> mappingCriteria: aJoin [
	self join: aJoin.
]

{ #category : #preparing }
RelationshipMapping >> multipleTableExpressionsFor: anExpression [
	^self referenceDescriptor multipleTableJoin
		collect: [:each | each asExpressionJoiningSource: anExpression toTarget: anExpression]
]

{ #category : #testing }
RelationshipMapping >> needsSpecialRowMapKey [
	"Return true if we have to use a special key object for the row map, rather than just our target"
	^self usesLinkTable.
]

{ #category : #initializing }
RelationshipMapping >> oneWayConstraintsFrom: oneTableSet to: anotherTableSet [
	| matches |
	matches := OrderedCollection new: 3.
	oneTableSet do: [:eachFromTable |
		 anotherTableSet do: [:eachToTable |
			matches addAll:  (eachFromTable foreignKeyConstraints
					select: [:eachConstraint | eachConstraint refersToTable: eachToTable])]].
	^matches.
]

{ #category : #mapping }
RelationshipMapping >> parametersIn: anElementBuilder [
	| parameters |
	self shouldUseFilteredRead ifTrue: [^anElementBuilder command parameters].
	parameters := IdentityDictionary new.
	self join
		mappableSourceFieldsDo:
			[:eachSource | parameters at: eachSource put: (anElementBuilder valueOfField: eachSource)].
	^parameters.
]

{ #category : #accessing }
RelationshipMapping >> proxyAction [
	"Return an action each proxy should take when it's instantiated. This is a two-argument block
		[:owner :target | "
	^proxyAction.
]

{ #category : #accessing }
RelationshipMapping >> proxyAction: aBlock [
	"Set an action each proxy should take when it's instantiated. This is a two-argument block
		[:owner :target | "
	proxyAction := aBlock.
]

{ #category : #mapping }
RelationshipMapping >> query [

	query isNil ifTrue: [self buildQuery].
	^query.
]

{ #category : #proxies }
RelationshipMapping >> queryFor: anObjectBuilder [ 
	"If we have a specific query we should use in this case, rather than our general one, construct it. Right now that only applies if we're using filtered reads"
	| basicQuery collection primaryKey newQuery cachedQuery filterBlock |
	self shouldUseFilteredRead 
		ifFalse: [^self query].
	cachedQuery := anObjectBuilder cachedQueryFor: self.
	cachedQuery isNil 
		ifTrue: 
			[basicQuery := self buildGeneralQueryIn: anObjectBuilder.
			self query tracing alsoFetchExpressions 
				do: [:each | basicQuery alsoFetch: each].
			collection := GlorpVirtualCollection new setQuery: basicQuery]
		ifFalse: [collection := cachedQuery collection].
	primaryKey := anObjectBuilder primaryKey.
	filterBlock := self descriptor keyFields size = 1 
				ifTrue: [[:objects :parameters | (objects at: 1) = primaryKey]]
				ifFalse: 
					[
					[:objects :parameters | 
					(1 to: primaryKey size) inject: true
						into: [:sum :i | sum and: [(primaryKey at: i) = (objects at: i)]]]].
	newQuery := FilteringQuery on: collection filter: filterBlock.
	newQuery collectBlock: [:each | each last].
	newQuery readsOneObject: self attribute isCollectionAttribute not.
	newQuery collectionType: self collectionType.
	anObjectBuilder cachedQueryFor: self is: newQuery.
	^newQuery
]

{ #category : #accessing }
RelationshipMapping >> referenceClass: aClass [
	self attribute type: aClass.
]

{ #category : #accessing }
RelationshipMapping >> referenceDescriptor [

	^self system descriptorFor: self referenceClass.
]

{ #category : #mapping }
RelationshipMapping >> referenceTableFieldFor: aField [
	^self usesLinkTable
		ifTrue: [nil]
		ifFalse: [self join targetForSource: aField].
]

{ #category : #api }
RelationshipMapping >> referencedIndependentObjectsFrom: anObject [

	| value |
	self canWrite ifFalse: [^#()].
	value := self getValueFrom: anObject.
	value == nil ifTrue: [^#()].
	^Array with: value.
]

{ #category : #initializing }
RelationshipMapping >> relatedTables [
	| otherTables possibleLinkTables |
	otherTables := self basicReferenceDescriptor tables.
	usesLinkTable ifFalse: [^otherTables].

	linkFields isNil ifFalse: [^(linkFields collect: [:each | each table]) asSet asArray].
	possibleLinkTables := self system allTables
		select:
			[:each | 
			(each hasConstraintsToAnyOf: self descriptor tables)
				and: [each hasConstraintsToAnyOf: otherTables]].
	possibleLinkTables size ~= 1
		ifTrue: [CannotAutomaticallyDetermineJoin new
			tables: possibleLinkTables;
			signal: 'Cannot automatically determine link table..'].
	^possibleLinkTables.
]

{ #category : #api }
RelationshipMapping >> relevantLinkTableFields [
	^linkFields.
]

{ #category : #api }
RelationshipMapping >> relevantLinkTableFields: aCollection [
	linkFields := aCollection.
]

{ #category : #mapping }
RelationshipMapping >> reverseJoin [

	reverseJoin isNil ifTrue: [reverseJoin := self joinFromLinkToReferenceTable].
	^reverseJoin.
]

{ #category : #accessing }
RelationshipMapping >> reverseJoin: aJoin [
	"Set the reverse join - the join from the link table to the target table. Normally this will be calculated based on the foreign key constraints, but in rare cases (e.g. a foreign key that may be to more than one table) you may want to set it explicitly"

	reverseJoin := aJoin.
]

{ #category : #mapping }
RelationshipMapping >> reverseMapping [
	"Construct the backwards mapping that corresponds to us. If it's using a link table, then we are at least potentially a toMany mapping. Otherwise, we can point backwards only to a single object."
	| mapping |
	^self usesLinkTable
		ifTrue: 
			[mapping := (ManyToManyMapping new)
				attributeName: #temporaryAttributeFromSubselect;
				referenceClass: self descriptor describedClass;
				join: self reverseJoin inverseJoin;
				descriptor: self descriptor.
			mapping reverseJoin: self join inverseJoin onlyJoinParts]
		ifFalse: 
			[(OneToOneMapping new)
				attributeName: #temporaryAttributeFromSubselect;
				referenceClass: self descriptor describedClass;
				join: self join inverseJoin;
				descriptor: self descriptor]
]

{ #category : #mapping }
RelationshipMapping >> rowMapKeyForSource: source target: target index: index [
	"Create the row map key. Make sure we're holding onto the real objects, so proxies don't time out on us"

	self needsSpecialRowMapKey ifFalse: [^target].
	(target yourSelf isNil or: [source yourSelf isNil]) ifTrue: [^nil].
	^rowMapKeyConstructorBlock isNil
		ifTrue:
			[self
				buildRowMapKeyForSource: source
				target: target
				index: index]
		ifFalse:
			[rowMapKeyConstructorBlock value: source yourSelf value: target yourSelf].
]

{ #category : #mapping }
RelationshipMapping >> setGeneralQueryRetrievalIn: newQuery basedOn: base phantom: phantomExpression [
	self descriptor keyFields
		do: [:eachField | newQuery retrieve: (phantomExpression getField: eachField)].
	newQuery retrieve: base.
]

{ #category : #accessing }
RelationshipMapping >> shouldProxy [

	^shouldProxy.
]

{ #category : #accessing }
RelationshipMapping >> shouldProxy: aBoolean [

	shouldProxy := aBoolean.
]

{ #category : #api }
RelationshipMapping >> shouldUseFilteredRead [
	^shouldUseFilteredRead.
]

{ #category : #api }
RelationshipMapping >> shouldUseFilteredRead: aBoolean [
	shouldUseFilteredRead := aBoolean.
]

{ #category : #'private/expressions' }
RelationshipMapping >> singleJoinFromLinkToReferenceTableForConstraints: constraints [
	"Generate the inverse mapping expression, i.e. the one connecting the link table to the reference table, using the foreign key constraints. We assume that if there's a general part, it applies only to the original join, and not to the reverse join that we're generating."

	| expression generalPart |
	expression := Join new.
	constraints do: [:eachConstraint | 
		eachConstraint sourceFields with: eachConstraint targetFields do: 
			[:eachSource :eachTarget |
				expression addSource: eachSource target: eachTarget]].
	generalPart := self join generalExpressionPart.
	^generalPart isNil ifTrue: [expression] ifFalse: [generalPart AND: expression].
]

{ #category : #accessing }
RelationshipMapping >> targetTableJoin [
	^targetTableJoin
]

{ #category : #accessing }
RelationshipMapping >> targetTableJoin: aJoin [
	"Set the join from the source table to the target table. Note that is is only required if you are using a link table, and in addition to the link table join need to connect from the source table directly to the target table as well.  This is *NOT* supposed to be a join from the link table to the target table. That's reverseJoin, and is calculated automatically. See relevantLinkTableFields if you need to give a hint, or linkTableJoin: if you want to set it explicitly."
	targetTableJoin := aJoin.
	aJoin owningMapping: self.
]

{ #category : #validation }
RelationshipMapping >> targetTables [
	^((self usesLinkTable ifTrue: [self reverseJoin] ifFalse: [self join]) allTargetFields collect: [:each | each table]) asSet.
]

{ #category : #processing }
RelationshipMapping >> trace: aTracing context: anExpression [
	"Currently we don't trace relationships across tables, so all we do here
is accumulate the list of embedded mappings"
	| newContext |
	(aTracing tracesThrough: self) ifFalse: [^self].
	newContext := anExpression get: self attributeName.
	aTracing addExpression: newContext.
	self referenceDescriptor trace: aTracing context: newContext.
]

{ #category : #api }
RelationshipMapping >> useFilteredRead [
	shouldUseFilteredRead := true.
]

{ #category : #accessing }
RelationshipMapping >> useLinkTable [
	usesLinkTable := true.
]

{ #category : #accessing }
RelationshipMapping >> usesLinkTable [
	^usesLinkTable
]

{ #category : #accessing }
RelationshipMapping >> usesLinkTable: anObject [
	usesLinkTable := anObject
]

{ #category : #validation }
RelationshipMapping >> validate [
	| targetJoinSourceFields targetJoinTargetTables |
	super validate.
	self join isNil ifTrue: [^self].
	targetJoinSourceFields := targetTableJoin isNil ifTrue: [#()] ifFalse: [targetTableJoin allSourceFields].
	targetJoinTargetTables :=  targetTableJoin isNil ifTrue: [#()] ifFalse: [targetTableJoin allTargetFields collect: [:each | each table]].
	(self join allSourceFields asArray, targetJoinSourceFields)
		do:
			[:each | 
			(each class == DatabaseField or: [each isKindOf: FunctionExpression]) 
				ifTrue: [(self descriptor tables includes: each table)
					ifFalse: [self error: 'Joins should go from the table(s) associated with this descriptor to the other table(s)']]].
	(self targetTables asArray, targetJoinTargetTables)
		do:
			[:each | 
			(self referenceDescriptor allTables includes: each)
				ifFalse:
					[self
						error:
							'Joins should go to the table(s) associated with the reference class of the mapping']].

	join allSourceFields asSet size = join allSourceFields size ifFalse: [self error: 'The same field occurs twice in the join. This might be legal, but is probably a cut and paste error.'].
	join allTargetFields asSet size = join allTargetFields size ifFalse: [self error: 'The same field occurs twice in the join. This might be legal, but is probably a cut and paste error.'].

	(self isExclusive and: [self canWrite not]) ifTrue: [self error: 'It is not meaningful to have an exclusive relationship that is read-only.'].
]

{ #category : #mapping }
RelationshipMapping >> valueOfField: aField fromObject: anObject [
	^self valueOfField: aField fromObject: anObject ifNone: [self error: 'Cannot find value'].
]

{ #category : #mapping }
RelationshipMapping >> valueOfField: aField fromObject: anObject ifNone: aBlock [
	"Return the value of a given field in our target object. Used in extracting primary keys when they are mapped via relationships"
	| targetField target |
	targetField := self referenceTableFieldFor: aField.
	targetField isNil ifTrue: [^aBlock value].
	target := self getValueFrom: anObject.
	"If it's a proxy and uninstantiated, we have to get the value from the proxy"
	(target isGlorpProxy and: [target isInstantiated not])
		ifTrue: [^target parameters at: aField].
	"If the object is instantiated, then we prefer to get the value from the object, because if it's non-primary key then the proxy may not know it, or it may vary from what the proxy has. Well, that seems unlikely, but try this anyway"
	self attribute 	
		loopOver: target 
		doing: [:index :eachTarget | | value |
			value := self referenceDescriptor valueOfField: targetField fromObject: eachTarget ifNone: [self].
			value == self ifFalse: [^value]].
	"We couldn't get it from the object, probably because it's unmapped. See if the proxy has it after all"
	target isGlorpProxy ifTrue: [^target parameters at: aField].
	"We couldn't get the value at all. This may mean that the object is new, so it has no proxies holding the value. Return nil and hope it's new and that it will all get figured out"
	^aBlock value.
]

{ #category : #mapping }
RelationshipMapping >> writeExtraInformationInto: aRowMap atKey: rowMapKey forSourceObject: sourceObject targetObject: targetObject  atIndex: index [
]
