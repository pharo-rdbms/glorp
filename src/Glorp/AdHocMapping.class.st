"
AdHocMapping is a configurable sort of mapping, done via two blocks. It's not easy to use, but gives you very direct access to the underlying mechanisms, so it should be possible to write mappings that are otherwise very complicated or impossible.

Instance Variables:
	fromDbMappingBlock	<BlockClosure>	The block we invoke when reading from the database. It's given arguments of the ""row"" we got from the database (note that this doesn't necessarily correspond to a single row, but is all the fields we selected in the query) , the elementBuilder associated with our containing object, and the ""context"", the expression from the query for what we're reading from the database. Typical usage is to use the context to translate a field into the appropriate aliased field from the query, and use the element builder to get the value of that field. e.g. elementBuilder valueOfField: (context translateField: someField) in: row
	mappedFields	<SequenceableCollection of: DatabaseField>	The list of fields we work with. We need to specify this so that Glorp knows that it needs to e.g. includes these fields in the list of those selected.
	shouldProxy	<Boolean>	Should we create a proxy for our target objects when we read an object containing this mapping.
	toDbMappingBlock	<BlockClosure>	The block we invoke when writing to the database. It takes as arguments the rowmap being created, the target object we are writing, and a dictionary of the rows we already have associated with this object. The block is expected to update the rowmap with the new information.


"
Class {
	#name : #AdHocMapping,
	#superclass : #Mapping,
	#instVars : [
		'fromDbMappingBlock',
		'toDbMappingBlock',
		'mappedFields',
		'shouldProxy'
	],
	#category : #'Glorp-Mappings'
}

{ #category : #'instance creation' }
AdHocMapping class >> forAttribute: aSymbol fromDb: fromBlock toDb: toBlock mappingFields: aFieldCollection [ 
	^super new 
		setAttribute: aSymbol
		fromDb: fromBlock
		toDb: toBlock
		mappingFields: aFieldCollection
]

{ #category : #'printing SQL' }
AdHocMapping >> allRelationsFor: rootExpression [
	"We may have multiple relationships."
	| tables rows result rightChild rightHandSide |
	tables := self mappedTables.
	rows := Dictionary new.
	tables do: [:each | rows at: each put: (DatabaseRow newForTable: each)].
	rightChild := rootExpression rightChild.
	rightHandSide := rightChild isConstantExpression ifTrue: [rightChild value] ifFalse: [rightChild].
	toDbMappingBlock value: rows value: rightHandSide value: Dictionary new. 
	result := nil.
	rows do: [:eachRow |
		| table |
		table := rootExpression leftChild base getTable: eachRow table.
		eachRow fieldsAndValidValuesDo: [:eachField :eachValue |  | newExp |
			newExp := (table getField: eachField) get: rootExpression relation withArguments: (Array with: eachValue).
			result := newExp AND: result.]].
	^result.
]

{ #category : #testing }
AdHocMapping >> controlsTables [
	^false
]

{ #category : #'printing SQL' }
AdHocMapping >> convertedDbValueOf: anObject [
	| tables rows |
	tables := self mappedTables.
	rows := Dictionary new.
	tables do: [:each | rows at: each put: (DatabaseRow newForTable: each)].
	toDbMappingBlock value: rows value: anObject.
	rows keysAndValuesDo: [:eachTable :eachRow |
		^eachRow at: mappedFields first].
]

{ #category : #mapping }
AdHocMapping >> field [
	| fields |
	fields := self mappedFields.
	fields size = 1 ifFalse: [self error: 'This mapping does not correspond to exactly one field'].
	^fields first
]

{ #category : #initialization }
AdHocMapping >> forAttribute: aSymbol fromDb: fromBlock toDb: toBlock mappingFields: aFieldCollection [
	self
		setAttribute: aSymbol
		fromDb: fromBlock
		toDb: toBlock
		mappingFields: aFieldCollection
]

{ #category : #testing }
AdHocMapping >> hasImpliedClauses [
	"We may imply more than one clause, or a clause which is different from the one directly implied by the relationship"
	^true
]

{ #category : #initialization }
AdHocMapping >> initialize [

	super initialize.
	self shouldProxy: false.
]

{ #category : #testing }
AdHocMapping >> isRelationship [
	"True when the mapping associates different persistent classes."

	^false
]

{ #category : #testing }
AdHocMapping >> isStoredInSameTable [
	^true.
]

{ #category : #public }
AdHocMapping >> mapFromObject: anObject intoRowsIn: aRowMap [

	| target sourceRows targetRows valueDescriptor |
	self canWrite ifFalse: [^self].
	target := self getValueFrom: anObject.
	target := self session realObjectFor: target.
	target := aRowMap mementoFor: target.
	sourceRows := Dictionary new: 3.
	targetRows := Dictionary new: 3.
	descriptor tables do: [:each |
		sourceRows at: each put: (aRowMap findOrAddRowForTable: each withKey: anObject)].
	valueDescriptor := self system descriptorFor: target.
	valueDescriptor isNil ifFalse: [
		valueDescriptor tables do: [:each |
			targetRows at: each put: (aRowMap findOrAddRowForTable: each withKey: target)]].
	toDbMappingBlock value: sourceRows value: target value: targetRows.
]

{ #category : #public }
AdHocMapping >> mapObject: anObject inElementBuilder: anElementBuilder [

	| readBlock row |
	row := anElementBuilder row.
	readBlock := [fromDbMappingBlock value: row value: anElementBuilder value: BaseExpression new].
	self shouldProxy 
		ifTrue: [self setValueIn: anObject to: (AdHocProxy readBlock: readBlock)]
		ifFalse: [self setValueIn: anObject to: readBlock value]
]

{ #category : #mapping }
AdHocMapping >> mappedFields [

	^mappedFields
]

{ #category : #mapping }
AdHocMapping >> mappedFieldsCount [

	^mappedFields size
]

{ #category : #mapping }
AdHocMapping >> referencedIndependentObjectsFrom: anObject [
	"Assumes that the only object this might affect is our primary attribute. That's probably valid. I think."
	| object otherDescriptor |
	object := self getValueFrom: anObject.
	(object isGlorpProxy and: [object isInstantiated not]) ifTrue: [^#()].
	otherDescriptor := self system descriptorFor: object.
	^otherDescriptor isNil ifTrue: [#()] ifFalse: [Array with: object]
]

{ #category : #initialization }
AdHocMapping >> setAttribute: aSymbol fromDb: fromBlock toDb: toBlock mappingFields: aFieldCollection [
 
	self attributeName: aSymbol.
	fromDbMappingBlock := fromBlock.
	toDbMappingBlock := toBlock.
	mappedFields := aFieldCollection
]

{ #category : #accessing }
AdHocMapping >> shouldProxy [

	^shouldProxy
]

{ #category : #accessing }
AdHocMapping >> shouldProxy: aBoolean [

	shouldProxy := aBoolean
]

{ #category : #mapping }
AdHocMapping >> trace: aTracing context: anExpression [
	^self
]

{ #category : #mapping }
AdHocMapping >> valueIn: anElementBuilder as: anExpression [
	^fromDbMappingBlock
		value: anElementBuilder row
		value: anElementBuilder
		value: anExpression
]
