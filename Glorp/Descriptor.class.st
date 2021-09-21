"
For each persistent class, there is a descriptor. This is what tells GLORP how to read and write objects of this class. The descriptor is not actually a very complicated object, because most of the information is in the mappings described below. But the descriptor does keep hold of a few per-class pieces of information, notably

Instance Variables:
	cachePolicy	<CachePolicy>	The cache policy to use. If left blank, default to what the system specifies.
	describedClass	<Class>	The persistent class that we map.
	mappedFields	<Collection of: DatabaseField>	The database fields we have mappings for (cached computed value)
	mappings	<(Collection of: Mapping)>	Our mappings.
	mapsPrimaryKeys	<Object>	Do we map the primary keys (cached computed value)
	multipleTableCriteria	<(Collection of: Join)>	description of multipleTableCriteria
	system	<DescriptorSystem>	The descriptor system that we belong to.
	tables	<(SequenceableCollection of: (DatabaseTable))>	The tables that we map
	typeResolver	<TypeResolver>	description of typeResolver


"
Class {
	#name : #Descriptor,
	#superclass : #Object,
	#instVars : [
		'tables',
		'mappings',
		'system',
		'mappedFields',
		'cachePolicy',
		'typeResolver',
		'mapsPrimaryKeys',
		'keyFields',
		'classModel',
		'multipleTableJoin',
		'imaginaryTableReplacements',
		'mappingsForFields'
	],
	#category : #'Glorp-Mappings'
}

{ #category : #'instance creation' }
Descriptor class >> new [

	^super new initialize
]

{ #category : #accessing }
Descriptor >> addMapping: aMapping [ 
	self basicAddMapping: aMapping.
	aMapping hasAttribute ifTrue: [
		(aMapping classModel attributeNamed: aMapping attribute name) == aMapping attribute ifFalse: [self error: 'If you have a classModel you must use newMapping: rather than addMapping:']]
]

{ #category : #accessing }
Descriptor >> addMultipleTableJoin: anExpression [ 
	self multipleTableJoin add: anExpression
]

{ #category : #accessing }
Descriptor >> addTable: aDatabaseTable [ 
	tables add: aDatabaseTable
]

{ #category : #'type mapping' }
Descriptor >> allDescribedConcreteClasses [
	^ self typeMapping allDescribedConcreteClasses
]

{ #category : #accessing }
Descriptor >> allMappingsForField: aField [ 
	"Return all of the mappings that use this field"
	^mappings select: [:each | each mappedFields includes: aField]
]

{ #category : #accessing }
Descriptor >> allTables [
	"Return all tables used by this descriptor or its subclasses. For a non-inheritance descriptor, this is the same as tables."
	^self typeResolver allTablesFor: self
]

{ #category : #accessing }
Descriptor >> basicAddMapping: aMapping [ 
	mappings := mappings, (Array with: aMapping).
	aMapping descriptor: self.
	self resetMappedFields
]

{ #category : #internal }
Descriptor >> buildReplacementTableSelect [
	"We have an imaginary table which is defined by selecting from our attributes instead of from the table. Build the query for that."

	| sourceMappings targetMappings mainQuery subQuery |
	mainQuery := nil.
	sourceMappings := imaginaryTableReplacements
		collect: [:each | self mappingForAttributeNamed: each first].
	targetMappings := imaginaryTableReplacements
		collect: [:each | self mappingForAttributeNamed: each last].
	sourceMappings
		with: targetMappings
		do:
			[:eachSourceMapping :eachTargetMapping | 
			subQuery := self
				buildReplacementTableSelectFrom: eachSourceMapping
				to: eachTargetMapping.
			mainQuery := mainQuery isNil
				ifTrue: [subQuery]
				ifFalse: [mainQuery unionAll: subQuery]].
	mainQuery session: self session.
	self primaryTable replacementSubSelect: mainQuery
]

{ #category : #internal }
Descriptor >> buildReplacementTableSelectFrom: sourceMapping to: targetMapping [
	"Build a select statement that combines the two mappings. We expect that both are relationships from a single object whose table is imaginary, so we need to knit together the information from the mappings to join the real tables directly together."

	| fullJoin targetJoin sourceJoin subQuery join |
	subQuery := self session queryClass read: sourceMapping referenceClass.
	subQuery session: self session.	
	subQuery setUpExpressions.
	"Invert because these will both start with the imaginary one on the left and we want to merge them together"
	sourceJoin := (sourceMapping join
		replacing: self primaryTable
		withEquivalenceFrom: targetMapping join) inverseJoin.
	targetJoin := targetMapping join
		replacing: self primaryTable
		withEquivalenceFrom: sourceMapping join.
	fullJoin := sourceJoin = targetJoin
		ifTrue: [sourceJoin]
		ifFalse: [sourceJoin , targetJoin].
	join := fullJoin asGeneralGlorpExpression asExpressionJoiningSource: subQuery baseExpression toTarget: subQuery baseExpression.
	subQuery addJoin: join.
	sourceMapping usesLinkTable ifTrue: [subQuery addJoin: (sourceMapping  expressionFromLinkToReferenceTableWithBase: subQuery baseExpression)].
	targetMapping usesLinkTable ifTrue: [subQuery addJoin: (targetMapping  expressionFromLinkToReferenceTableWithBase: subQuery baseExpression)].
	self
		setRetrievalExpressionsInReplacementTableForQuery: subQuery
		fromMapping: sourceMapping
		toMapping: targetMapping.
	^subQuery.
]

{ #category : #accessing }
Descriptor >> cachePolicy [
	cachePolicy isNil ifTrue: [^system cachePolicy].
	^cachePolicy
]

{ #category : #accessing }
Descriptor >> cachePolicy: aCachePolicy [
	cachePolicy:= aCachePolicy
]

{ #category : #accessing }
Descriptor >> classModel [
	^classModel
]

{ #category : #accessing }
Descriptor >> classModel: aGlorpClassModel [
	classModel := aGlorpClassModel
]

{ #category : #'type resolution' }
Descriptor >> classesRequiringIndependentQueries [

	^ self typeResolver classesRequiringIndependentQueriesFor: self describedClass
]

{ #category : #testing }
Descriptor >> computeMapsPrimaryKeys [
	| primaryKeyFields |
	self tables isEmpty ifTrue: [^false].
	primaryKeyFields := self primaryTable primaryKeyFields.
	primaryKeyFields isEmpty ifTrue: [^false].
	primaryKeyFields
		do: [:each | (self mappedFields anySatisfy: [ :eachMappedField |
			eachMappedField = each]) ifFalse: [^false]].
	^true.
]

{ #category : #deleting }
Descriptor >> createDeleteRowFor: anObject table: aTable in: aRowMap [
	"Create records for rows that require deletion"

	(self primaryKeyMappingsFor: aTable)
		do: [:each | 
			each first mapFromObject: anObject intoRowsIn: aRowMap]
]

{ #category : #deleting }
Descriptor >> createDeleteRowsFor: anObject in: aRowMap [
	"Create records for rows that require deletion"

	|  |
	anObject class == self describedClass ifFalse: [self error: 'wrong descriptor for this object'].
	"If we don't map primary keys, then we're something that gets embedded, and a delete isn't necessary"
	self mapsPrimaryKeys ifFalse: [^self]. 

	self tables do: [:eachTable |
		self createDeleteRowFor: anObject table: eachTable in: aRowMap.
		aRowMap rowForTable: eachTable withKey: anObject ifPresent: [:eachRow | eachRow forDeletion: true]].
	"It's possible that we might not have any direct mapping for a secondary table's primary keys, so 
allow the multiple table criteria to specify them if that's the only one. If they're not, then they don't do any harm"
	self multipleTableJoin do: [:each |
		each mapFromSource: anObject andTarget: anObject intoRowsIn: aRowMap.
		each allTables do: [:eachTable |
			aRowMap rowForTable: eachTable withKey: anObject ifPresent: [:eachRow | eachRow forDeletion: true]]].

	self mappings do: [:each | each  createDeleteRowFor: anObject in: aRowMap]
]

{ #category : #mapping }
Descriptor >> createRowsFor: anObject in: aRowMap [
	| row |
	anObject class == self describedClass
		ifFalse: [self error: 'wrong descriptor for this object'].
	mappings do: [:each | 
			each stopIfDebuggingWrite.
			each mapFromObject: anObject intoRowsIn: aRowMap].

	"If we haven't written out our primary keys, then make sure we do so, but if absolutely none of our mappings have written anything, then just ignore it."
	row := aRowMap rowForTable: self primaryTable withKey: anObject ifAbsent: [^self].
	self primaryTable primaryKeyFields do: [:each | 
		self setFieldValue: each 	in: row from: anObject].

	"This is a bit of a hack/heuristic. If the multiple table join is an outer join, and the row doesn't exist yet, then assume we won't need it and don't do the join. It means none of our mappings wrote to it. Hope that in that case no one else's will. It seems reasonable that we wouldn't map an object to multiple tables unless we planned to map some field within it, but it's still a bit of a risk."
	self multipleTableJoin do: [:each | 
		(each isOuterJoin not or: [each allTables anySatisfy: [:eachTable | 
			aRowMap includesRowForTable: eachTable withKey: anObject]]) 
				ifTrue: [
					each
						mapFromSource: anObject
						andTarget: anObject
						intoRowsIn: aRowMap]]
]

{ #category : #tracing }
Descriptor >> defaultTracing [
	^Tracing new
]

{ #category : #accessing }
Descriptor >> describedClass [
	^classModel describedClass
]

{ #category : #accessing }
Descriptor >> describedClass: aClass [
	classModel := self system classModelFor: aClass
]

{ #category : #internal }
Descriptor >> describedConcreteClassFor: row withBuilder: builder [
	"Lookup the class that is represented by the row when there is a possibility
		of this row representing any class within a hierarchy. "
	^self typeResolver describedConcreteClassFor: row withBuilder: builder descriptor: self
]

{ #category : #'creating mappings' }
Descriptor >> directMapping [
	^self newMapping: DirectMapping
]

{ #category : #'creating mappings' }
Descriptor >> directMappingFor: attributeName [
	"Create a direct mapping from the attribute of this name to the field in the table with a matching name. For convenience when there's a good correspondence between the field and instance variable names."
	| field |
	self tables do: [:each |
		field := each fieldNamed: attributeName ifAbsent: [nil] caseSensitive: false].
	field isNil ifTrue: [self error: 'Cannot find field named ', attributeName printString].
	^self directMapping from: attributeName to: field
]

{ #category : #accessing }
Descriptor >> directMappingForField: aField [ 
	"Return a single, direct mapping for this field.  There may conceivably be more than one, 
	but they all have to agree, so it shouldn't matter as far as the value. There may also be none.
	Exclude pseudoVariable mappings by ensuring that the detected mapping can be read into an object."

	^(self mappingsForFields at: aField ifAbsent: [^nil]) 
		detect: [:each | each isRelationship not & each canRead]
		ifNone: [nil]
]

{ #category : #accessing }
Descriptor >> directMappingsForField: aField [ 
	"Return all the relationship mappings that use this field"

	^(self mappingsForFields at: aField ifAbsent: [^#()]) 
		reject: [:each | each isRelationship]
]

{ #category : #'creating mappings' }
Descriptor >> fieldFor: aFieldOrString [
	"We allow either a field or a string naming the field, and return the appropriate field object."
	aFieldOrString isString ifFalse: [^aFieldOrString].
	self tables do: [:each |
		| field | 
		field := each fieldNamed: aFieldOrString.
		field isNil ifFalse: [^field]].
	self error: 'Cannot find field ', aFieldOrString, '. Please pass in the field object'
]

{ #category : #accessing }
Descriptor >> fieldsForSelectStatement [
	| myFields inheritedFields |
	myFields := self mappedFields.
	inheritedFields := self typeResolver fieldsForSelectStatement.
	^inheritedFields isEmpty ifTrue: [myFields] ifFalse: [myFields, inheritedFields]
]

{ #category : #accessing }
Descriptor >> imaginaryTableIsDefinedByRelationFrom: sourceAttributeName to: targetAttributeName [
	self imaginaryTableReplacements add: (Array with: sourceAttributeName with: targetAttributeName)
]

{ #category : #accessing }
Descriptor >> imaginaryTableReplacements [
	imaginaryTableReplacements isNil ifTrue: [imaginaryTableReplacements := OrderedCollection new: 4].
	^imaginaryTableReplacements.
]

{ #category : #accessing }
Descriptor >> initialize [

	mappings := Array new.
	tables := OrderedCollection new: 1
]

{ #category : #validation }
Descriptor >> initializeRuntimeMappings [
	"Do any setups we need to make sure that my mappings are initialized for runtime"

	self mappings do: [:eachMapping | eachMapping initializeRuntimeMappings]
]

{ #category : #testing }
Descriptor >> isForAssociation [
	^self describedClass == Association
]

{ #category : #testing }
Descriptor >> isPrimaryKeyAutogeneratedFor: anObject [
	"Answer if the primary keys are database-generated"
	anObject class == self describedClass
		ifFalse: [ self error: 'Wrong descriptor for this object' ].
	^ self primaryTable primaryKeyFields allSatisfy: [ :field | field type isSerial ]
]

{ #category : #testing }
Descriptor >> isTypeMappingRoot [
	^self typeResolver isTypeMappingRoot: self
]

{ #category : #accessing }
Descriptor >> keyFields [
	"Return the fields we use as primary keys for caching purposes. Typically, these are just going to be the primary keys of our primary table. Objects intended to be embedded won't map the primary keys at all. Weird objects may supply their own keys (e.g. functions rather than fields directly)"

	^keyFields == nil
		ifTrue:
			[self mapsPrimaryKeys
				ifTrue: [self primaryTable primaryKeyFields]
				ifFalse: [nil]]
		ifFalse: [keyFields].
]

{ #category : #accessing }
Descriptor >> keyFields: aFieldCollection [
	"Set the fields we use as primary keys for caching purposes. Typically, these are just going to be the primary keys of our primary table"
	keyFields := aFieldCollection
]

{ #category : #accessing }
Descriptor >> mappedFields [
	"Return all the fields that are mapped, in the order that they occur in the table. This specifically omits fields that are not in the selected set of tables (so e.g. even if a mapping uses a link table field, if it's not in the list of tables to select from, we don't want it). We also include mapped, non-constant expressions, which we would normally expect to be functions"
	mappedFields isNil ifTrue: [
		| fieldSet |
		fieldSet := IdentitySet new: mappings size.
		mappings do: [:each | fieldSet addAll: each fieldsForDescriptorSelectStatement].
		mappedFields := OrderedCollection new.
		tables do: [:each |
			each fields do: [:eachField | (fieldSet includes: eachField) ifTrue: [mappedFields add: eachField]]].
		fieldSet do: [:each | 
 			(each isGlorpExpression and: [each isConstantExpression not]) ifTrue: [mappedFields add: each]]].
	^mappedFields.
]

{ #category : #accessing }
Descriptor >> mappedFieldsCount [
	"Return all the fields that are mapped, in the order that they occur in the table. This specifically omits fields that are not in the selected set of tables (so e.g. even if a mapping uses a link table field, if it's not in the list of tables to select from, we don't want it). We also include mapped, non-constant expressions, which we would normally expect to be functions"
	^self mappedFields size
]

{ #category : #accessing }
Descriptor >> mappingForAttributeNamed: aSymbol [

	^mappings detect: [:each | each attributeName == aSymbol] ifNone: [
		self isForAssociation ifTrue: [self valueDescriptor mappingForAttributeNamed: aSymbol]]
]

{ #category : #accessing }
Descriptor >> mappingForField: aField [

	^(self mappingsForFields at: aField ifAbsent: [^nil]) first
]

{ #category : #mapping }
Descriptor >> mappings [
	^ReadStream on: mappings
]

{ #category : #accessing }
Descriptor >> mappingsForFields [
	"Return a dictionary from fields to the mappings that contain them. This specifically omits fields that are not in the selected set of tables (so e.g. even if a mapping uses a link table field, if it's not in the list of tables to select from, we don't want it). We also include mapped, non-constant expressions, which we would normally expect to be functions"
	mappingsForFields isNil ifTrue: [
		mappingsForFields := IdentityDictionary new: mappings size.
		mappings do: [:eachMapping | 
			eachMapping mappedFields do: [:eachField | 
				(mappingsForFields at: eachField ifAbsentPut: [OrderedCollection new]) add: eachMapping]]].
	^mappingsForFields.
]

{ #category : #testing }
Descriptor >> mapsPrimaryKeys [
	mapsPrimaryKeys isNil ifTrue: [mapsPrimaryKeys := self computeMapsPrimaryKeys].
	^mapsPrimaryKeys
]

{ #category : #accessing }
Descriptor >> multipleTableJoin [
	multipleTableJoin isNil
		ifTrue: [multipleTableJoin := OrderedCollection new: 1].
	^multipleTableJoin.
]

{ #category : #'creating mappings' }
Descriptor >> newMapping: aClass [
	| mapping |
	mapping := aClass new.
	self basicAddMapping: mapping.
	^mapping
]

{ #category : #'creating mappings' }
Descriptor >> oneToOneMapping [
	^self newMapping: OneToOneMapping
]

{ #category : #mapping }
Descriptor >> populateObject: anObject inBuilder: anElementBuilder [
	"Answer an object using the values for the specified fields."

	mappings
		do: [:each | 
			each stopIfDebuggingRead.
			each mapObject: anObject inElementBuilder: anElementBuilder]
]

{ #category : #mapping }
Descriptor >> primaryKeyCollectionFor: anObject [
	"Find the primary key for anObject. Always return it as a collection."
	| fields |
	anObject yourSelf class == self describedClass
		ifFalse: [self error: 'Wrong descriptor for this object'].
	fields := self primaryTable primaryKeyFields.
	^fields collect: [:each | self valueOfField: each fromObject: anObject]
]

{ #category : #mapping }
Descriptor >> primaryKeyExpressionFor: anObject basedOn: anExpression relation: aSymbol [
	"anObject can be either a real domain object, or a constant expression containing it, or an expression representing the object"

	| expression value pkMappings |
	value := anObject isGlorpExpression
		ifTrue:
			[anObject isConstantExpression ifTrue: [anObject value] ifFalse: [anObject]]
		ifFalse:
			[anObject class == self describedClass
				ifFalse: [self error: 'Wrong descriptor for this object'].
			anObject].
	self isForAssociation ifTrue: [
		"We just rewrite as self value = x"
		^((anExpression get: #value) get: aSymbol withArguments: (Array with:  value)) rewriteEquality].
	expression := nil.
	pkMappings := self primaryKeyMappings.
	(pkMappings isEmpty ifTrue: [self mappings] ifFalse: [pkMappings])
		do:
			[:each | 
			| clause |
			clause := each
				expressionFor: value
				basedOn: anExpression
				relation: aSymbol.
			expression := aSymbol = #<> ifTrue: [clause OR: expression] ifFalse: [clause AND: expression]].
	^expression
]

{ #category : #mapping }
Descriptor >> primaryKeyFor: anObject [
	"Find the primary key for anObject. If it's a single field, just return a single value. Otherwise, return a collection. Caller is expected to know what to expect."
	| fields |
	anObject class == self describedClass
		ifFalse: [self error: 'Wrong descriptor for this object'].
	fields := self primaryTable primaryKeyFields.
	^fields size = 1
		ifTrue: [self valueOfField: (fields at: 1) fromObject: anObject]
		ifFalse:
			[fields collect: [:each | self valueOfField: each fromObject: anObject]]
]

{ #category : #mapping }
Descriptor >> primaryKeyMappings [
	"Return things that map to our primary key fields. Prefer direct mappings"
	| fields pkMappings |
	fields := self primaryTable primaryKeyFields.
	pkMappings := OrderedCollection new: fields size.
	fields do: [:each |  | mapping |
		mapping := self directMappingForField: each.
		mapping isNil ifTrue: [mapping := self mappingForField: each].
		mapping isNil ifFalse: [pkMappings add: mapping]].
	^pkMappings
]

{ #category : #deleting }
Descriptor >> primaryKeyMappingsFor: aTable [
	"Return our primary key mappings as a collection of mappings, one collection per primary key"

	| allMappings |
	allMappings := Dictionary new: aTable primaryKeyFields size.
	aTable primaryKeyFields
		do: [:each | 
			| mappingsForField |
			mappingsForField := self mappingsForFields at: each ifAbsent: [nil].
			mappingsForField isNil ifFalse: [allMappings at: each put: mappingsForField]].
	^allMappings
]

{ #category : #accessing }
Descriptor >> primaryTable [
	tables isEmpty ifTrue: [^nil].
	^tables first.
]

{ #category : #printing }
Descriptor >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: '('.
	self describedClass printOn: aStream.
	aStream nextPutAll: ')'
]

{ #category : #internal }
Descriptor >> readBackNewRowInformationFor: anObject [
]

{ #category : #mapping }
Descriptor >> readBackNewRowInformationFor: anObject in: aRowMap [ 
	anObject yourSelf class == self describedClass ifFalse: [self error: 'wrong descriptor for this object'].
	mappings do: [:each | each readBackNewRowInformationFor: anObject fromRowsIn: aRowMap]
]

{ #category : #internal }
Descriptor >> referencedIndependentObjectsFrom: anObject do: aBlock [

	mappings do: [:each |
		(each referencedIndependentObjectsFrom: anObject) do: [:eachReferencedObject |
			aBlock value: eachReferencedObject]]
]

{ #category : #internal }
Descriptor >> referencedIndependentObjectsWithMappingsFrom: anObject do: aBlock [

	mappings do: [:each |
		(each referencedIndependentObjectsFrom: anObject) do: [:eachReferencedObject |
			aBlock value: eachReferencedObject value: each]]
]

{ #category : #'type mapping' }
Descriptor >> registerTypeResolver: aResolver [
	self registerTypeResolver: aResolver abstract: false
]

{ #category : #'type mapping' }
Descriptor >> registerTypeResolver: aResolver abstract: shouldBeAbstract [
	shouldBeAbstract ifFalse: [ self beAbstract ].
	aResolver register: self
]

{ #category : #accessing }
Descriptor >> relationshipMappingForField: aField [ 
	"Return a single, direct mapping for this field. There may conceivably be more than one, but they all have to agree, so it shouldn't matter as far as the value. There may also be none."

	^(self mappingsForFields at: aField ifAbsent: [^nil]) 
		detect: [:each | each isRelationship]
		ifNone: [nil]
]

{ #category : #accessing }
Descriptor >> relationshipMappingsForField: aField [ 
	"Return all the relationship mappings that use this field, excluding pseudoVariable mappings"

	^(self mappingsForFields at: aField ifAbsent: [^#()]) 
		select: [:each | each isRelationship & each canRead ].
]

{ #category : #accessing }
Descriptor >> removeMapping:  aMapping [

	mappings := mappings copyWithout: aMapping
]

{ #category : #accessing }
Descriptor >> resetMappedFields [
	mappedFields := nil
]

{ #category : #accessing }
Descriptor >> session [

	^system session
]

{ #category : #mapping }
Descriptor >> setFieldValue: each in: row from: anObject [
	"Try to set the value of the field, which is normally a primary key field, in the row, based on data in the object. Useful for the case where we have only a relationship mapping to the object that holds our primary key, and it is uninstantiated"
	| value |
	(row wrapperAt: each ifAbsent: [FieldValueWrapper new]) hasValue
		ifFalse:
			[value := self valueOfField: each fromObject: anObject ifNone: [^self].
			"We're using this to get primary key fields. Nil is not a useful answer."
			value isNil ifTrue: [^self].
			row at: each put: value]
]

{ #category : #internal }
Descriptor >> setRetrievalExpressionsInReplacementTableForQuery: subQuery fromMapping: sourceMapping toMapping: targetMapping [
	self primaryTable fields
		do:
			[:each | 
			| sourceReplacement replacement expression |
			sourceReplacement := sourceMapping join targetForSource: each.
			replacement := sourceReplacement isNil
				ifTrue: [targetMapping join targetForSource: each]
				ifFalse: [sourceReplacement].
			expression := replacement isGlorpExpression
				ifTrue: [replacement] 
				ifFalse: [(BaseExpression new getTable: replacement table) getField: replacement].
			expression alias: each name.
			subQuery retrieve: expression]
]

{ #category : #tracing }
Descriptor >> setupTracing: aTracing [
	"Find all the other objects that need to be read when this one is read"

	self trace: aTracing context: aTracing base
]

{ #category : #testing }
Descriptor >> supportsOrdering [

	typeResolver isNil ifTrue: [^true].
	^typeResolver supportsOrderingFor: self.
]

{ #category : #accessing }
Descriptor >> system [
	^system
]

{ #category : #accessing }
Descriptor >> system: anObject [
	system := anObject
]

{ #category : #accessing }
Descriptor >> table [
	tables isEmpty ifTrue: [^nil].
	^tables first.
]

{ #category : #accessing }
Descriptor >> table: aDatabaseTable [
	
	| table |
	table := aDatabaseTable isString
		ifTrue: [table := self system tableNamed: aDatabaseTable]
		ifFalse: [aDatabaseTable].
	tables add: table
]

{ #category : #accessing }
Descriptor >> tables [
	^tables
]

{ #category : #'creating mappings' }
Descriptor >> toManyMapping [
	^self newMapping: ToManyMapping
]

{ #category : #tracing }
Descriptor >> trace: aTracing context: anExpression [
	"For each mapping, check if the relationship is involved in the set of things
to be read"
	mappings do: [:each |
		each trace: aTracing context: anExpression]
]

{ #category : #accessing }
Descriptor >> typeMapping [
	^mappings detect: [ :each | each isTypeMapping ] ifNone: [
		| mapping |
		mapping := IdentityTypeMapping new.
		self addMapping: mapping.
		mapping]
]

{ #category : #accessing }
Descriptor >> typeMapping: aMapping [
	self addMapping: aMapping
]

{ #category : #'type mapping' }
Descriptor >> typeMappingCriteriaIn: base [
	| r l |
	r := ConstantExpression for: self typeMapping keys.
	l := FieldExpression forField: self typeMapping field basedOn: base.
	^l in: r
]

{ #category : #'type resolution' }
Descriptor >> typeMappingRoot [
	^self typeResolver typeMappingRoot
]

{ #category : #'type resolution' }
Descriptor >> typeMappingRootDescriptor [
	^self typeResolver typeMappingRootDescriptor
]

{ #category : #accessing }
Descriptor >> typeResolver [
	typeResolver isNil
		ifTrue: [  IdentityTypeResolver new register: self  ].
	^typeResolver
]

{ #category : #accessing }
Descriptor >> typeResolver: anObject [
	typeResolver := anObject
]

{ #category : #validation }
Descriptor >> validate [
	"Do any tests we can to make sure that this definition makes sense in this context"
	| readableMappings attributeNames |
	self system validateDescriptor: self.
	self mappings do: [:eachMapping |
		eachMapping validate].
	"Validate that we have at most one readable mapping for an instance variable"
	readableMappings := self mappings select: [:each | each canRead and: [each isTypeMapping not and: [each attributeName isEmpty not]]].
	attributeNames := readableMappings collect: [:each | each attributeName].
	(attributeNames asSet size = readableMappings size) 
		ifFalse: [MultipleMappingsForInstanceVariable new
					model: self describedClass;
					readableMappings: readableMappings;
					signal].

	self typeResolver validate.
]

{ #category : #accessing }
Descriptor >> valueDescriptor [
	| valueMapping |
	valueMapping := self mappingForAttributeNamed: #value.
	valueMapping isNil ifTrue: [^nil].
	^valueMapping referenceDescriptor
]

{ #category : #mapping }
Descriptor >> valueOfField: aField fromObject: anObject [
	^self valueOfField: aField fromObject: anObject ifNone: [nil]
]

{ #category : #mapping }
Descriptor >> valueOfField: aField fromObject: anObject ifNone: aBlock [
	| directMapping notFound |
	directMapping := self directMappingForField: aField.
	directMapping isNil
		ifFalse: [^directMapping valueOfField: aField fromObject: anObject].
	notFound := Object new.
	(self relationshipMappingsForField: aField)
		do:
			[:each | 
			| candidate |
			(each hasValueThatCanProvideField: aField from: anObject)
				ifTrue: [
					candidate := each valueOfField: aField fromObject: anObject ifNone: [notFound].
					candidate == notFound ifFalse: [^candidate]]].
	^aBlock value
]
