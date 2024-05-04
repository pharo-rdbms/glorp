"
This is the abstract superclass for all Glorp mappings. A mapping defines how one particular instance variable will be mapped into and out of the database. There is considerable variation among the subclasses.

Subclasses must implement the following messages:
	accessing
		allTables
	mapping
		mapFromObject:intoRowsIn:
		mapObject:inElementBuilder:
		referencedIndependentObjectsFrom:
		trace:context:
	testing
		controlsTables
		isRelationship
		isStoredInSameTable
		mappedFields

Instance Variables:
	attribute	<GlorpAttributeModel>	The description of the instance variable we map.
	canRead	<Boolean>	Is this mapping allowed to read.
	canWrite	<Boolean>	Is this mapping allowed to write.
	debugRead	<Boolean>	For debugging purposes. If true, we will halt when this mapping is about to read..
	debugWrite	<Boolean>	For debugging purposes. If true, we will halt when this mapping is about to write.
	descriptor	<Descriptor>	The descriptor that contains this mapping.


"
Class {
	#name : 'Mapping',
	#superclass : 'Object',
	#instVars : [
		'descriptor',
		'attribute',
		'debugRead',
		'debugWrite'
	],
	#category : 'Glorp-Mappings',
	#package : 'Glorp',
	#tag : 'Mappings'
}

{ #category : 'printing SQL' }
Mapping >> allRelationsFor: rootExpression do: aBlock andBetweenDo: anotherBlock [
	"Normal mappings just operate on a single expression"
	aBlock value: rootExpression leftChild value: rootExpression rightChild
]

{ #category : 'accessing' }
Mapping >> allTables [

	self subclassResponsibility.
]

{ #category : 'mapping' }
Mapping >> applicableMappingForObject: anObject [ 
	"For polymorphism with conditional mappings"
	
	^self
]

{ #category : 'accessing' }
Mapping >> attribute [
	attribute isNil ifTrue: [attribute := GlorpAttributeModel new].
	^attribute.
]

{ #category : 'accessing' }
Mapping >> attributeAccessor [
	^self attribute
]

{ #category : 'accessing' }
Mapping >> attributeName [
	^self attribute name
]

{ #category : 'accessing' }
Mapping >> attributeName: aSymbol [
	| oldAttribute symbolName |
	symbolName := aSymbol asSymbol.
	oldAttribute := attribute.
	attribute := self classModel attributeNamed: symbolName.
	oldAttribute isNil
		ifTrue: [self initializeAttribute]
		ifFalse: [attribute copyFrom: oldAttribute]
]

{ #category : 'api' }
Mapping >> beExclusive [
	self error: 'Only relationship mappings can be exclusive'.
]

{ #category : 'accessing' }
Mapping >> beForPseudoVariable [
	self attribute beForPseudoVariable.
]

{ #category : 'accessing' }
Mapping >> beReadOnly [
	self canWrite: false.
]

{ #category : 'testing' }
Mapping >> canBeUsedForRetrieve [
	"Return true if this is a valid argument for a retrieve: clause"
	self isRelationship ifFalse: [^true].
	^self isToManyRelationship not.
]

{ #category : 'accessing' }
Mapping >> canRead [
	^self attribute canRead
]

{ #category : 'accessing' }
Mapping >> canWrite [
	^self attribute canWrite
]

{ #category : 'accessing' }
Mapping >> canWrite: aBoolean [
	self attribute canWrite: aBoolean
]

{ #category : 'accessing' }
Mapping >> classModel [
	"If we don't have one, just make a temporary one. We'll fix it later"
	descriptor isNil ifTrue: [^GlorpClassModel new].
	^self descriptor classModel.
]

{ #category : 'testing' }
Mapping >> controlsTables [
	"Return true if this type of mapping 'owns' the tables it's associated with, and expression nodes using this mapping should alias those tables where necessary"

	self subclassResponsibility
]

{ #category : 'private' }
Mapping >> convertedDbValueOf: stValue [ 
	"Mappings in general don't know how to do type conversion. Subclasses that deal with database primitive types should override."
	^stValue
]

{ #category : 'initialization' }
Mapping >> copyAttributeAttributes [
	"We have an attributemodel that was created before we actually had a descriptor. It's possible that it had properties set. Make sure we copy them. If necessary, initialize things that require it."
	| oldAttribute |
	oldAttribute := attribute.
	attribute := self classModel attributeNamed: oldAttribute name type: oldAttribute type collectionType: oldAttribute collectionType.
	attribute copyFrom: oldAttribute.
	self initializeAttribute
]

{ #category : 'mapping' }
Mapping >> createDeleteRowFor: anObject in: aRowMap [
	"Only applies to mappings that write into link tables"
]

{ #category : 'debugging' }
Mapping >> debugRead [
	^debugRead
]

{ #category : 'debugging' }
Mapping >> debugRead: aBoolean [
	debugRead := aBoolean
]

{ #category : 'debugging' }
Mapping >> debugWrite [
	^debugWrite
]

{ #category : 'debugging' }
Mapping >> debugWrite: aBoolean [
	debugWrite := aBoolean
]

{ #category : 'accessing' }
Mapping >> descriptor [
	^descriptor
]

{ #category : 'accessing' }
Mapping >> descriptor: aDescriptor [
	descriptor := aDescriptor.
	attribute isNil ifFalse: [self copyAttributeAttributes]
]

{ #category : 'mapping' }
Mapping >> expressionFor: anObject [
	"Return an expression representing the value of the object. This can be nil, an object value or values, an expression, or a collection of expressions (for a composite key, if we're passed an expression)"

	anObject isNil ifTrue: [^#(nil)].
	anObject isGlorpExpression ifFalse: [
		^self mappedFields collect: [:each | 	
			self valueOfField: each fromObject: anObject]].
	^self mappedFields
		collect: [:each | (anObject getField: each)]
]

{ #category : 'mapping' }
Mapping >> expressionFor: anObject basedOn: anExpression relation: aSymbol [
	"Return our expression using the object's values. e.g. if this was a direct mapping from id->ID and the object had id: 3, then return TABLE.ID=3. Used when rewriting object=object into field=field"

	| myValue result |
	myValue := self expressionFor: anObject.
	result := nil.
	myValue with: self join allTargetFields do: [:eachValue :eachField |
		| source |
		source := anExpression get: self attribute name.
		source hasDescriptor ifTrue: [source := source getField: eachField].
		result := (source get: aSymbol withArguments: (Array with: eachValue)) AND: result].
	^result
]

{ #category : 'accessing' }
Mapping >> fieldsForDescriptorSelectStatement [
	"Return a collection of fields that this mapping will read from a row when the containing object is read, as opposed to when we're specifically told to use this field. Normally it amounts to the same thing."
	^self mappedFields
]

{ #category : 'accessing' }
Mapping >> fieldsForSelectStatement [
	"Return a collection of fields that this mapping will read from a row"
	self canRead ifFalse: [^#()].
	^self mappedFields
]

{ #category : 'public' }
Mapping >> getValueFrom: anObject [

	^self attribute getValueFrom: anObject
]

{ #category : 'testing' }
Mapping >> hasAttribute [
	"Return true if this maps an attribute, which is normally true"
	^true
]

{ #category : 'testing' }
Mapping >> hasImpliedClauses [
	"Return true if this implies multiple sql clauses"
	^false
]

{ #category : 'testing' }
Mapping >> hasValueThatCanProvideField: aField from: anObject [
	"Return true if we have enough information in ourselves to populate our fields. The only time this won't be true is if we're either holding an uninstantiated proxy or have a to-many relationship mapping with an empty collection."
	^true
]

{ #category : 'testing' }
Mapping >> includesSubFieldsInSelectStatement [
	^false
]

{ #category : 'initialization' }
Mapping >> initialize [
	debugRead := false.
	debugWrite := false.
]

{ #category : 'initialization' }
Mapping >> initializeAttribute [
	"This is where we can initialize aspects of the attribute, if required. The motivating example is initializing the collection type of the attribute if it wasn't set. We need it to have some type, but we don't want to initialize it while we're doing basic initialization and aren't yet properly attached to a descriptor or class model"
]

{ #category : 'validation' }
Mapping >> initializeRuntimeMappings [
	"I do nothing but my subclasses might"

	^self
]

{ #category : 'api' }
Mapping >> isExclusive [
	^false
]

{ #category : 'api' }
Mapping >> isExclusive: aBoolean [
	aBoolean ifTrue: [self error: 'Only relationship mappings can be exclusive'].
]

{ #category : 'accessing' }
Mapping >> isForPseudoVariable [
	^self attribute isForPseudoVariable or: [self attributeAccessor isValid not]
]

{ #category : 'testing' }
Mapping >> isRelationship [
	"True when the mapping associates different persistent classes."

	^self subclassResponsibility
]

{ #category : 'testing' }
Mapping >> isStoredInSameTable [
	"True when the mapping is between two objects that occupy the same table, e.g. an embedded mapping."

	^self subclassResponsibility
]

{ #category : 'testing' }
Mapping >> isToManyRelationship [
	^false
]

{ #category : 'testing' }
Mapping >> isTypeMapping [
	^false
]

{ #category : 'preparing' }
Mapping >> joinExpressionFor: anExpression [

	^nil
]

{ #category : 'iterating' }
Mapping >> loopOverAttributeOf: anObject doing: aTwoArgumentBlock [
	"Loop over the target, which we extract from anObject, and iterate over it evaluating the block. For things that aren't collections, iterating means just run once. Note that the argument is expected to be an instance of our descriptor, as opposed to the attribute method, which expects the target object"
	| target |
	target := self getValueFrom: anObject.
	self attribute loopOver: target doing: aTwoArgumentBlock
]

{ #category : 'mapping' }
Mapping >> mapFromObject: anObject intoRowsIn: aRowMap [

	self subclassResponsibility
]

{ #category : 'mapping' }
Mapping >> mapObject: anObject inElementBuilder: anObject1 [
	self subclassResponsibility
]

{ #category : 'testing' }
Mapping >> mappedFields [
	self subclassResponsibility
]

{ #category : 'mapping' }
Mapping >> mappedTables [
	^(self mappedFields collect: [:each | each table]) asSet
]

{ #category : 'testing' }
Mapping >> mapsPrimaryKeys [
	^(self mappedFields detect: [:each | each isPrimaryKey] ifNone: [nil]) notNil
]

{ #category : 'testing' }
Mapping >> mapsSimpleObject [
	"Return true if we know that we map something without a descriptor. For some mappings, like ad hoc or conditional, we don't really know, so we default to false"
	^false
]

{ #category : 'preparing' }
Mapping >> multipleTableExpressionsFor: anExpression [

	^#()
]

{ #category : 'proxies' }
Mapping >> newProxyIn: anObjectBuilder [ 
	| proxy |
	proxy := Proxy new.
	proxy query: (self queryFor: anObjectBuilder).
	proxy glorpProxyAction: self proxyAction.
	^proxy
]

{ #category : 'public' }
Mapping >> printOn: aStream [

	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: (attribute isNil ifTrue: [''] ifFalse: [self attributeName]) ;
		nextPutAll: ')'
]

{ #category : 'proxies' }
Mapping >> proxyAction [
	^nil
]

{ #category : 'mapping' }
Mapping >> readBackNewRowInformationFor: anObject fromRowsIn: aRowMap [ 
	"
	self subclassResponsibility. ?"
]

{ #category : 'accessing' }
Mapping >> readOnly [
	^self canWrite not
]

{ #category : 'accessing' }
Mapping >> readOnly: aBoolean [
	self canWrite: aBoolean not
]

{ #category : 'accessing' }
Mapping >> referenceClass [
	^self attribute type
]

{ #category : 'mapping' }
Mapping >> referencedIndependentObjectsFrom: anObject [

	self subclassResponsibility
]

{ #category : 'accessing' }
Mapping >> session [
	
	^self descriptor session
]

{ #category : 'public' }
Mapping >> setValueIn: anObject to: aValue [
	self canRead ifFalse: [^self].
	self attribute setValueIn: anObject to: aValue
]

{ #category : 'debugging' }
Mapping >> stopIfDebuggingRead [
	debugRead ifTrue: [self halt].
]

{ #category : 'debugging' }
Mapping >> stopIfDebuggingWrite [
	debugWrite ifTrue: [self halt].
]

{ #category : 'accessing' }
Mapping >> system [
	
	^self descriptor system
]

{ #category : 'mapping' }
Mapping >> trace: aTracing context: anExpression [

	self subclassResponsibility
]

{ #category : 'mapping' }
Mapping >> translateFields: anOrderedCollection [ 
	"Normal mappings don't translate"
	^anOrderedCollection
]

{ #category : 'mapping' }
Mapping >> translateTable: aTable [
	"If we have a field translation, return the translated (i.e. real) table to use. This ideally allows us to use either the real table in which something is embedded, or the imaginary table"
	^aTable
]

{ #category : 'validation' }
Mapping >> validate [
	self validateAttribute
]

{ #category : 'validation' }
Mapping >> validateAttribute [
	self canWrite ifTrue: [self attribute validateCanWrite].
	self canRead ifTrue: [self attribute validateCanRead]
]

{ #category : 'mapping' }
Mapping >> valueOfField: aField fromObject: anObject [
	self error: 'Can''t get value of field'
]
