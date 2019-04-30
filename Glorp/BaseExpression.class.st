"
This represents the base object that we're looking for in a query. So if we ask to read: Person, then we will have a base expression corresponding to Person. Even if what we end up retrieving is not part of the Person object, it remains the base, because it's what defines our point of view.

Instance Variables:
	availableSubSelectNumber	<Integer>	As the base of the query, we keep track of how many subselects there are. New subselects will need to have a unique number so they can prefix their tables as e.g. s1t1 when aliasing them, and the number comes from this counter.
	descriptor	<Descriptor>	The descriptor for the class we're looking for.


"
Class {
	#name : #BaseExpression,
	#superclass : #ObjectExpression,
	#instVars : [
		'descriptor',
		'availableSubSelectNumber'
	],
	#category : 'Glorp-Expressions'
}

{ #category : #accessing }
BaseExpression >> additionalExpressions [
	| expressions |
	expressions := OrderedCollection new.
	self descriptor typeMapping addTypeMappingCriteriaTo: expressions in: self.
	expressions addAll: self multipleTableExpressions.
	^expressions
]

{ #category : #preparing }
BaseExpression >> additionalExpressionsOn: anExpression [
	^#().
]

{ #category : #preparing }
BaseExpression >> asExpressionJoiningSource: source toTarget: target [
	"Create a general expression which represents this relationship where the values of the targets (which are normally parameters) are supplied out of the context provided by 'target' and the source fields are referencing things out of the context of source. Produces something suitable for ANDing into an expression when doing a join
   Example: If we had CUSTOMER.ADDRESS_ID = ADDRESS.ID as a parameter, and we want to AND this into an expression [:customer | customer address street = 'Main'] then we have customer as a base, and we get 
	(customer.ADDRESS.STREET = 'Main') AND (customer.CUSTOMER.ADDRESS_ID = customer.ADDRESS.ID)
	The primary key expression for the relationship has been translated into field references into the customer and address tables in a particular context."

	^source.
]

{ #category : #preparing }
BaseExpression >> availableSubSelectNumber [
	availableSubSelectNumber := availableSubSelectNumber isNil ifTrue: [1] ifFalse: [availableSubSelectNumber + 1].
	^availableSubSelectNumber.
]

{ #category : #api }
BaseExpression >> base [

	^nil.
]

{ #category : #testing }
BaseExpression >> canBeUsedForRetrieve [
	"Return true if this is a valid argument for a retrieve: clause"
	^true.
]

{ #category : #accessing }
BaseExpression >> canHaveBase [
	"Return true if this type of expression can have a base expression on which other things can be built. We don't have a base, but we *are* a base, so return true"
	^true.
]

{ #category : #testing }
BaseExpression >> canPrint [
	"Return true if we can print into a where clause"
	^false.
]

{ #category : #printing }
BaseExpression >> className [

	^'Base'.
]

{ #category : #preparing }
BaseExpression >> controlsTables [

	^true.
]

{ #category : #accessing }
BaseExpression >> descriptor [

	^descriptor
]

{ #category : #accessing }
BaseExpression >> descriptor: aDescriptor [
	descriptor := aDescriptor
]

{ #category : #preparing }
BaseExpression >> fieldsForSelectStatement [
	^self descriptor mappedFields.
]

{ #category : #api }
BaseExpression >> getParameter: aDatabaseField [ 
	^ParameterExpression forField: aDatabaseField basedOn: self.
]

{ #category : #accessing }
BaseExpression >> hasDescriptor [

	^self descriptor notNil.
]

{ #category : #accessing }
BaseExpression >> mappedFields [
	^self descriptor mappedFields collect: [:each | self translateField: each].
]

{ #category : #testing }
BaseExpression >> mapsSimpleObject [
	"Try to do a fast test for this, to look for the pseudo-descriptors that direct to-many mappings use."
	^self descriptor mappings size = 1 and: [(self descriptor mappingForAttributeNamed: #myValue) notNil].
]

{ #category : #accessing }
BaseExpression >> multipleTableExpressions [
	^self descriptor multipleTableJoin 
		collect: [:each | each asExpressionJoiningSource: self toTarget: self]
]

{ #category : #printing }
BaseExpression >> printOn: aStream [ 
	aStream
		nextPutAll: self className;
		nextPut: $(.
	self printTreeOn: aStream.
	aStream nextPut: $)
]

{ #category : #printing }
BaseExpression >> printOnlySelfOn: aStream [ 
	self descriptor isNil ifTrue: [aStream nextPutAll: 'Empty Base'. ^self].
	aStream print: self descriptor describedClass.
	self printTableAliasesOn: aStream
]

{ #category : #printing }
BaseExpression >> printSQLOn: aStream withParameters: aDictionary [ 
	"Do nothing. We're not printable"
]

{ #category : #printing }
BaseExpression >> printSelectSQLOn: aStream withParameters: aDictionary [ 
	"Normally, we're not printable, but we might be if we're inverting a direct to-many mapping. In that case, there should only be one mapped field"
	self descriptor mappedFields do: [:each | (self translateField: each) printSQLOn: aStream withParameters: aDictionary].
]

{ #category : #printing }
BaseExpression >> printTreeOn: aStream [ 
	aStream 
		print: (self descriptor isNil ifTrue: [nil] ifFalse: [self descriptor describedClass])
]

{ #category : #navigating }
BaseExpression >> queryLevelBaseExpression [

	^self
]

{ #category : #preparing }
BaseExpression >> rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression [
	anExpression isNil ifTrue: [^aBaseExpression].
	anExpression == self ifTrue: [^aBaseExpression].
	^ultimateBaseExpression isNil ifTrue: [self] ifFalse: [ultimateBaseExpression].
]

{ #category : #api }
BaseExpression >> referenceClass [
	"Return the class that our mapping refers to, if we have a mapping. If we're a base expression, just return our class, and if we're a table expression, just return nil."
	^self descriptor describedClass.
]

{ #category : #accessing }
BaseExpression >> system [
	self descriptor isNil ifTrue: [^nil].
	^self descriptor system.
]

{ #category : #accessing }
BaseExpression >> table [

	^self descriptor primaryTable.
]

{ #category : #accessing }
BaseExpression >> tables [

	^self descriptor isNil ifTrue: [#()] ifFalse: [self descriptor tables].
]

{ #category : #preparing }
BaseExpression >> tablesToPrint [
	"We derive the base's tables from the fields that are being selected, but make sure that at least the primary table is listed."
	self descriptor tables isEmpty ifTrue: [^#()].
	^Array with: (self aliasedTableFor: self descriptor primaryTable).
]

{ #category : #accessing }
BaseExpression >> targetDescriptor [
	self halt
]

{ #category : #accessing }
BaseExpression >> trueBase [
	^self.
]

{ #category : #navigating }
BaseExpression >> ultimateBaseExpression [

	^self
]

{ #category : #mapping }
BaseExpression >> valueInBuilder: anElementBuilder [
	"If we ever get here, this is because we're being used as the reverse of a direct to-many mapping, so we expect to have a descriptor with only one mapping, named #myValue"
	| mapping |
	mapping := self descriptor mappingForAttributeNamed: #myValue.
	^mapping valueInBuilder: anElementBuilder as: (self get: #myValue) field.
]
