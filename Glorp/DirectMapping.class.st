"
This is the simplest type of mapping, it maps directly between an instance variable that holds some ""primitive"" type, and a field in a database table.

Instance Variables:
	converter	<DatabaseConverter>	The converter used to transform the data into database form and back again. This will be automatically computed based on the types defined, if possible, but for more complex conversions (e.g. booleans into strings in the database) a converter can be explicitly specified.
	field	<DatabaseField | FunctionExpression>	The field to write to. One complication is that (for reading purposes) the field may be a function. So we might have a mapping that reads from the TO_UPPER of some field, or even an aggregate function like MAX.


"
Class {
	#name : #DirectMapping,
	#superclass : #Mapping,
	#instVars : [
		'field',
		'converter',
		'shouldProxy',
		'query'
	],
	#category : #'Glorp-Mappings'
}

{ #category : #'instance creation' }
DirectMapping class >> from: attributeName to: field [

	^self from: attributeName
			type: field impliedSmalltalkType
			to: field
]

{ #category : #'instance creation' }
DirectMapping class >> from: attributeName type: aClass to: field [

	^(self new)
		attributeName: attributeName;
		field: field;
		type: aClass.
]

{ #category : #'instance creation' }
DirectMapping class >> fromPseudoVariable: attributeName to: field [

	^self fromPseudoVariable: attributeName
			type: field impliedSmalltalkType
			to: field
]

{ #category : #'instance creation' }
DirectMapping class >> fromPseudoVariable: attributeName type: aClass to: field [

	^(self new)
		attributeName: attributeName;
		field: field;
		beForPseudoVariable
]

{ #category : #mapping }
DirectMapping >> buildQuery [
	"We just want to read our main object back again. So we create a join from our primary key fields to themselves. One side will remain field references, the other side will turn into parameters when it's converted to a where clause."
	| whereClause |
	whereClause := Join new.
	descriptor primaryTable primaryKeyFields do: [:each |
		whereClause addSource: each target: each].
	query := self session queryClass readOneOf: descriptor describedClass where: whereClause.
	query retrieve: self attribute name.
	query session: self session.
	^query.
]

{ #category : #testing }
DirectMapping >> controlsTables [
	"Return true if this type of method 'owns' the tables it's associated with, and expression nodes using this mapping should alias those tables where necessary"

	^false
]

{ #category : #mapping }
DirectMapping >> convertValueToDatabaseForm: aValue [
	
	converter isNil ifTrue: [^aValue].
	^converter convertedDbValueOf: aValue
]

{ #category : #private }
DirectMapping >> convertedDbValueOf: stValue [ 
	^converter isNil
		ifTrue: [stValue]
		ifFalse: [converter convert: stValue toDatabaseRepresentationAs: self field type]
]

{ #category : #private }
DirectMapping >> convertedStValueOf: dbValue [ 
	^(converter isNil)
		ifTrue: [dbValue]
		ifFalse: [converter convert: dbValue fromDatabaseRepresentationAs: self field type]
]

{ #category : #accessing }
DirectMapping >> converter [
	^converter
]

{ #category : #accessing }
DirectMapping >> converter: aDatabaseConverter [
	converter := aDatabaseConverter
]

{ #category : #mapping }
DirectMapping >> expressionFor: anObject basedOn: anExpression relation: aSymbol [
	"Return our expression using the object's values. e.g. if this was a direct mapping from id->ID and the object had id: 3, then return TABLE.ID=3"

	| value |
	value := anObject isNil
		ifTrue: [nil]
		ifFalse:
			[anObject isGlorpExpression
				ifTrue: [anObject getMapping: self named: self attributeName]
				ifFalse: [anObject glorpIsCollection
					ifTrue: [anObject collect: [:each | self convertedDbValueOf: (attribute getValueFrom: each)]]
					ifFalse: [self convertedDbValueOf: (attribute getValueFrom: anObject)]]].
	^(anExpression get: self attribute name) get: aSymbol withArguments: (Array with: value)
]

{ #category : #accessing }
DirectMapping >> field [
	^field
]

{ #category : #accessing }
DirectMapping >> field: aDatabaseFieldOrExpression [
	field := (Dialect isBlock: aDatabaseFieldOrExpression)
		ifTrue: [
			self beReadOnly.
			aDatabaseFieldOrExpression asGlorpExpressionOn: (BaseExpression new descriptor: descriptor)]
		ifFalse: [aDatabaseFieldOrExpression]
]

{ #category : #accessing }
DirectMapping >> fieldsForDescriptorSelectStatement [
	"Return a collection of fields that this mapping will read from a row when the containing object is read, as opposed to when we're specifically told to use this field. Normally it amounts to the same thing, but if a direct mapping is proxied, we don't want its field when the parent is read"
	^self shouldProxy ifTrue: [self descriptor primaryTable primaryKeyFields] ifFalse: [super fieldsForDescriptorSelectStatement]
]

{ #category : #'initialize-release' }
DirectMapping >> from: anAttributeName to: aField [

	| type |
	self attributeName: anAttributeName.
	self field: (descriptor fieldFor: aField).
	type := self attribute type isNil ifTrue: [field impliedSmalltalkType] ifFalse: [self attribute type].
	self type: type
]

{ #category : #'initialize-release' }
DirectMapping >> from: anAttributeName type: aClass to: aField [

	self
		attributeName: anAttributeName;
		field: aField;
		type: aClass
]

{ #category : #'initialize-release' }
DirectMapping >> fromPseudoVariable: anAttributeName to: aField [

	^self fromPseudoVariable: anAttributeName
		type: aField impliedSmalltalkType
		to: aField
]

{ #category : #'initialize-release' }
DirectMapping >> fromPseudoVariable: anAttributeName type: aClass to: aField [

	self from: anAttributeName type: aClass to: aField.
	self beForPseudoVariable
]

{ #category : #'initialize-release' }
DirectMapping >> initialize [
	super initialize.
	shouldProxy := false.
]

{ #category : #testing }
DirectMapping >> isRelationship [
	"True when the mapping associates different persistent classes."

	^false
]

{ #category : #testing }
DirectMapping >> isStoredInSameTable [

	^true
]

{ #category : #mapping }
DirectMapping >> mapFromObject: anObject intoRowsIn: aRowMap [

	^self mapFromObject: anObject toTarget: anObject puttingRowsIn: aRowMap
]

{ #category : #mapping }
DirectMapping >> mapFromObject: anObject toTarget: target puttingRowsIn: aRowMap [

	| dbValue value row |
	self canWrite ifFalse: [^self].
	value := self getValueFrom: anObject.
	value := self session realObjectFor: value ifNone: [^self].
	dbValue := self convertedDbValueOf: value.
	row := aRowMap findOrAddRowForTable: self field table withKey: target.
	row at: field put: dbValue
]

{ #category : #mapping }
DirectMapping >> mapObject: anObject inElementBuilder: anElementBuilder [
	| value |
	self shouldProxy ifTrue: [
		^self setValueIn: anObject to: ((self newProxyIn: anElementBuilder)
						session: descriptor session;
						parameters: (self parametersIn: anElementBuilder);
						glorpOwner: anObject;
						glorpArmProxy)].
	value := self valueInBuilder: anElementBuilder.
	self setValueIn: anObject to: value
]

{ #category : #testing }
DirectMapping >> mappedFields [
	"Return a collection of fields that this mapping will write into any of the containing object's rows"

	^Array with: self field
]

{ #category : #testing }
DirectMapping >> mapsSimpleObject [
	^true
]

{ #category : #mapping }
DirectMapping >> parametersIn: anElementBuilder [
	| parameters |
	parameters := IdentityDictionary new.
	descriptor primaryTable primaryKeyFields do: [:each | parameters at: each put: (anElementBuilder valueOfField: each)].
	^parameters
]

{ #category : #'printing SQL' }
DirectMapping >> printSQLOn: aStream withParameters: aDictionary [
	self field printSQLOn: aStream withParameters:aDictionary
]

{ #category : #mapping }
DirectMapping >> query [

	query isNil ifTrue: [self buildQuery].
	^query.
]

{ #category : #mapping }
DirectMapping >> queryFor: anObjectBuilder [
	"If we have a specific query we should use in this case, rather than our general one, construct it. Right now that only applies if we're using filtered reads"
	^self query
]

{ #category : #mapping }
DirectMapping >> readBackNewRowInformationFor: anObject fromRowsIn: aRowMap [ 
	| value row |
	field isGenerated ifFalse: [^self].
	self canWrite ifFalse: [^false].
	row := aRowMap findOrAddRowForTable: self field table withKey: anObject.
	value := self convertedStValueOf: (row at: field ifAbsent: [^self]).
	attribute setValueIn: anObject to: value
]

{ #category : #enumerating }
DirectMapping >> referencedIndependentObjectsFrom: anObject [

	^#()
]

{ #category : #'initialize-release' }
DirectMapping >> setConverterBetween: aClass and: aDbField [ 
	aClass isNil ifTrue: [^self].
	converter := descriptor ifNotNil: 
					[descriptor system converterBetweenStType: aClass andField: aDbField]
				ifNil: [aDbField converterForStType: aClass]
]

{ #category : #accessing }
DirectMapping >> shouldProxy [

	^shouldProxy
]

{ #category : #accessing }
DirectMapping >> shouldProxy: aBoolean [

	shouldProxy := aBoolean
]

{ #category : #mapping }
DirectMapping >> trace: aTracing context: anExpression [
	^self
]

{ #category : #accessing }
DirectMapping >> type: aClass [
	self attribute type: aClass.
	field isNil ifFalse: [
		self setConverterBetween: aClass and: field]
]

{ #category : #validation }
DirectMapping >> validate [
	super validate.
	(field isGlorpExpression and: [self readOnly not]) ifTrue: [self error: 'Mappings to functions cannot be written'].
]

{ #category : #mapping }
DirectMapping >> valueIn: anElementBuilder as: anExpression [
	| dbValue valueToGet |
	valueToGet := anExpression canTranslateFields 
		ifTrue: [anExpression translateField: field] 
		ifFalse: [anExpression].
	dbValue := anElementBuilder
		valueOfField: valueToGet.
	^self convertedStValueOf: dbValue
]

{ #category : #mapping }
DirectMapping >> valueInBuilder: anElementBuilder [
	^self valueInBuilder: anElementBuilder as: field
]

{ #category : #mapping }
DirectMapping >> valueInBuilder: anElementBuilder as: anExpression [
	| dbValue |
	dbValue := anElementBuilder valueOfField: anExpression.
	^self convertedStValueOf: dbValue
]

{ #category : #mapping }
DirectMapping >> valueOfField: aField fromObject: anObject [
	field = aField ifFalse: [self error: 'Mapping doesn''t describe field'].
	^self convertedDbValueOf: (self getValueFrom: anObject)
]
