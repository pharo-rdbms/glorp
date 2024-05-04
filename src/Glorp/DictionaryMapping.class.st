"
This allows us to map a dictionary into tables. It should, I hope, support arbitrarily either mapping to single fields, or to objects, for either the key or the value. At the moment, it at least passes the tests for the value->object and value->value cases.

Instance Variables:
	keyMapping	<DatabaseMapping>	The mapping to use to read/write the key. It should be for an attribute named #key.
	valueMapping	<DatabaseMapping>	The mapping to use to read/write the value. It should be for an attribute named #value. Note that this is optional, and isn't a full blown mapping, because if we have a relationship, we will normally just use this mapping to describe it directly. If we have a direct mapping for the value, then we have this odd situation where we use the Join from this mapping, but the direct mapping to control the read/write of the variable.
	associationDescriptor	<Descriptor>	We manipulate the key/value pairs as associations in some places, and have a mock descriptor for association, specific to this mapping, which is used to get the key/value.



"
Class {
	#name : 'DictionaryMapping',
	#superclass : 'ToManyMapping',
	#instVars : [
		'keyMapping',
		'valueMapping',
		'associationDescriptor'
	],
	#category : 'Glorp-Mappings',
	#package : 'Glorp',
	#tag : 'Mappings'
}

{ #category : 'mapping' }
DictionaryMapping >> associationClassModel [
	| model |
	model := GlorpClassModel for: Association.
	model newAttributeNamed: #key.
	model newAttributeNamed: #value.
	^model
]

{ #category : 'mapping' }
DictionaryMapping >> associationDescriptor [
	associationDescriptor isNil ifTrue: [
		associationDescriptor := Descriptor new.
		associationDescriptor system: self system.
		associationDescriptor classModel: self associationClassModel].
	^associationDescriptor.
]

{ #category : 'accessing' }
DictionaryMapping >> basicReferenceDescriptor [
	^self system descriptorFor: self basicReferenceClass
]

{ #category : 'mapping' }
DictionaryMapping >> buildQuery [
	| keyExpression valueExpression |
	query := super buildQuery.
	keyExpression := self keyExpression.
	valueExpression := self valueExpression.
	query retrieveDictionaryWithKey: keyExpression value: valueExpression.
	^query
]

{ #category : 'mapping' }
DictionaryMapping >> buildRowMapKeyForSource: source target: target index: index [
	^self mapsSimpleObject 
		ifTrue: [
			MultipleRowMapKey
				with: target yourSelf
				with: source yourSelf
				with: index]
		ifFalse: [super buildRowMapKeyForSource: source target: target index: index]
]

{ #category : 'mapping' }
DictionaryMapping >> chooseBaseForMapping: aMapping from: base and: phantomExpression [
	aMapping isNil ifTrue: [^base].
	^(aMapping mappedFields
		allSatisfy: [:each | base tables includes: each table])
		ifTrue: [base]
		ifFalse: [phantomExpression]
]

{ #category : 'accessing - defaults' }
DictionaryMapping >> defaultCollectionType [
	^Dictionary
]

{ #category : 'accessing' }
DictionaryMapping >> field [
	^self valueField
]

{ #category : 'testing' }
DictionaryMapping >> glorpCanHaveDescriptorDirectly [
	"We allow instances of ourselves to have a descriptor, which normally only classes can do. This is so that we can have multiple different descriptors in use for e.g. String, depending on the particular usage."
"	^self mapsSimpleObject."
	^true
]

{ #category : 'initialization' }
DictionaryMapping >> initialize [
	super initialize.
	usesLinkTable := true.
]

{ #category : 'validation' }
DictionaryMapping >> initializeRuntimeMappings [
	super initializeRuntimeMappings.
	self initializeValueMapping.
]

{ #category : 'initialization' }
DictionaryMapping >> initializeValueMapping [
	| referenceDescriptor |
	self descriptor system privateAndBasicAddDescriptorFor: self as: self associationDescriptor.
	(self associationDescriptor classModel attributeNamed: #key) type: self attribute keyType.
	(self associationDescriptor classModel attributeNamed: #value) type: self attribute type.
	referenceDescriptor := self referenceDescriptor.
	(referenceDescriptor isNil or: [referenceDescriptor tables isEmpty]) ifTrue: [self initializeValueMappingJoin].
]

{ #category : 'initialization' }
DictionaryMapping >> initializeValueMappingJoin [
	| tables |
	"We don't know which of these will come first in the descriptor, so call the other initialization if it looks like we have enough information, and it hasn't been done"
	self referenceDescriptor isNil ifTrue: [self initializeValueMapping].
	"Have we already done this?"
	self referenceDescriptor tables isEmpty ifFalse: [^self].

	tables := self targetTables asArray.
	tables do: [:each | self referenceDescriptor addTable: each].
	(self referenceDescriptor newMapping: DirectMapping) 
		from: #key to: self keyField.
	self mapsSimpleObject 
		ifTrue: [
			(self referenceDescriptor newMapping: DirectMapping) 
			from: #value to: self valueField]
		ifFalse: [
			(self referenceDescriptor newMapping: OneToOneMapping)
				attributeName: #value;	
				linkFields: self linkFields;
				usesLinkTable: self usesLinkTable;
				join: self join;
				controlsTables: false].
]

{ #category : 'mapping' }
DictionaryMapping >> keyExpression [
	"Return the expression to use for our key. The key can be built using data from either the target object, or from the link table, so build the expression on one or the other, as appropriate"
	 | base intermediate |
	base := BaseExpression new.
	intermediate := (self descriptor tables includes: keyMapping mappedFields first table)
		ifTrue: [base] 
		ifFalse: [base getTable: keyMapping mappedFields first table].
	^intermediate getMapping: keyMapping named: #key
]

{ #category : 'accessing' }
DictionaryMapping >> keyField [
	^keyMapping field
]

{ #category : 'accessing' }
DictionaryMapping >> keyField: aDatabaseField [
	keyMapping := self newMapping: DirectMapping.
	keyMapping attributeName: #key.
	keyMapping from: #key to: aDatabaseField
]

{ #category : 'accessing' }
DictionaryMapping >> keyMapping [
	^keyMapping
]

{ #category : 'accessing' }
DictionaryMapping >> keyMapping: aMapping [
	keyMapping := aMapping
]

{ #category : 'accessing' }
DictionaryMapping >> mappedFields [
	"Return a collection of fields that this mapping will write into any of the containing object's rows"

	| fields |
	fields := super mappedFields copy.
	fields addAll: keyMapping mappedFields.
	valueMapping isNil ifFalse: [
		fields addAll: valueMapping mappedFields].
	^fields
]

{ #category : 'testing' }
DictionaryMapping >> mapsSimpleObject [
	^valueMapping notNil and: [valueMapping mapsSimpleObject]
]

{ #category : 'accessing' }
DictionaryMapping >> name [
	"This can get called when we're masquering as a class, for purposes of indexing descriptors, so just print something useful"
	^self printString
]

{ #category : 'testing' }
DictionaryMapping >> needsSpecialRowMapKey [
	^super needsSpecialRowMapKey or: [
		self mapsSimpleObject]
]

{ #category : 'mapping' }
DictionaryMapping >> newMapping: aMappingClass [
	"Implement this so that we can create our sub-mappings without having them added to the parent descriptor as independent mappings"
	| mapping |
	mapping := aMappingClass new.
	mapping descriptor: self associationDescriptor.
	descriptor resetMappedFields.
	^mapping
]

{ #category : 'mapping' }
DictionaryMapping >> pseudoDescriptor [
	"Return a pretend descriptor for our reference class. Since that class is a primitive, it won't have a real descriptor, and it may vary by usage anyway"
	| pseudoDescriptor |
	pseudoDescriptor := Descriptor new.
	pseudoDescriptor system: descriptor system.
	^pseudoDescriptor
]

{ #category : 'accessing' }
DictionaryMapping >> referenceClass [
	"Return ourselves as the reference class, as a sort of a proxy for what we really want, which is a primitive, and varies according to the relationship anyway. Note that we have stuffed in a descriptor in the system, with ourselves (this instance) as the class."
"	^self mapsSimpleObject ifTrue: [self] ifFalse: [super referenceClass]."
	^self
]

{ #category : 'accessing' }
DictionaryMapping >> referenceDescriptor [
	| ref |
	ref := super referenceDescriptor.
	^ref isNil 
		ifTrue: [
			"This means we haven't yet added our fake descriptor, and are in initialization, so just return the descriptor for the 'real' reference class"
			self system descriptorFor: self basicReferenceClass]
		ifFalse: [ref]
]

{ #category : 'mapping' }
DictionaryMapping >> setGeneralQueryRetrievalIn: newQuery basedOn: base phantom: phantomExpression [
	| keyExpression valueExpression collType keyExpressionBase valueExpressionBase |
	self descriptor primaryKeyMappings
		do:
			[:eachMapping | newQuery retrieve: (phantomExpression get: eachMapping attributeName)].
	keyExpressionBase := self
		chooseBaseForMapping: keyMapping
		from: base
		and: phantomExpression.
	keyExpression := self keyExpression asGlorpExpressionOn: keyExpressionBase.
	valueExpressionBase := self
		chooseBaseForMapping: valueMapping
		from: base
		and: phantomExpression.
	valueExpression := self valueExpression
		asGlorpExpressionOn: valueExpressionBase.
	collType := (GlorpDictionaryDescription new)
		keyExpression: keyExpression;
		valueExpression: valueExpression.
	newQuery collectionType: collType.
	newQuery retrieve: base
]

{ #category : 'validation' }
DictionaryMapping >> validate [
	self initializeValueMapping.
	super validate.
	self attribute isDictionaryAttribute
		ifFalse: [self error: 'Dictionary Mapping that does not have a dictionary type in the attribute'].

	"The reason you can't do this, is that we end up throwing away the primary key of the target table when we read in the objects, and we have no way to properly do deletes/updates without that information"
	(self usesLinkTable and: [self mapsSimpleObject]) ifTrue: [self error: 'Dictionary mappings to simple objects cannot use a link table'].
]

{ #category : 'mapping' }
DictionaryMapping >> valueExpression [
	 | base intermediate |
	valueMapping isNil ifTrue: [ ^[:each | each value] ].
	base := BaseExpression new.
	intermediate := (self descriptor tables includes: valueMapping mappedFields first table)
		ifTrue: [base] 
		ifFalse: [base getTable: valueMapping mappedFields first table].
	^intermediate getMapping: valueMapping named: #value.
]

{ #category : 'accessing' }
DictionaryMapping >> valueField [
	^valueMapping field
]

{ #category : 'accessing' }
DictionaryMapping >> valueField: aDatabaseField [
	| mapping |
	mapping := self newMapping: DirectMapping.
	mapping attributeName: #value.
	mapping from: #value to: aDatabaseField.
	self valueMapping: mapping
]

{ #category : 'accessing' }
DictionaryMapping >> valueMapping [
	^valueMapping
]

{ #category : 'accessing' }
DictionaryMapping >> valueMapping: aMapping [
	valueMapping := aMapping
]

{ #category : 'mapping' }
DictionaryMapping >> writeExtraInformationInto: aRowMap atKey: rowMapKey forSourceObject: sourceObject targetObject: targetObject atIndex: eachKey [
	"Write out any additional information that goes in the link table or else the target table. That means our key, if necessary. If we have a specific value mapping, rather than just using the normal attributes of this mapping, then write that as well. That normally happens when our value is simple"
	
	"We need to know if the key mapping is trying to write to the link table, or to the target. If it's to the link table, then we always use the row map key. If it's to the target table, then we need to use whatever is appropriate for the target table, which is a row map key if we have a simple target, and otherwise it's just the target object"
	| target |
	target := (keyMapping mappedTables includes: self linkTable)
		ifTrue: [rowMapKey]
		ifFalse: [self mapsSimpleObject ifTrue: [rowMapKey] ifFalse: [targetObject]].
	keyMapping
		mapFromObject: eachKey -> nil
		toTarget: target
		puttingRowsIn: aRowMap.

	valueMapping isNil ifTrue: [^self].
	"I'm not sure this will ever be relevant. If the value mapping goes to the link table, then does that mean the key is really the value? And if so, why not just consider the other one to be the link?"
	target := (valueMapping mappedTables includes: self linkTable)
		ifTrue: [rowMapKey]
		ifFalse: [self mapsSimpleObject ifTrue: [rowMapKey] ifFalse: [targetObject]].
	valueMapping
		mapFromObject: nil -> targetObject
		toTarget: target
		puttingRowsIn: aRowMap
]
