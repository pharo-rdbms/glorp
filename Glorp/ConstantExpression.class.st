"
This represents a literal constant. So, if object field = 2, this would be the (2) part.

Instance Variables:
	alias	<String>	Sometimes in queries we want to retrieve something specific in a column value. So, e.g. ""select name as one, 2 as two from ...."" Where we get back columns named 'one' and 'two', where the value of 'two' is always 2. The alias tells us what to alias the column for this as, if we're using this as something to be selected.
	value	<Object>	The literal constant value.


"
Class {
	#name : #ConstantExpression,
	#superclass : #GlorpExpression,
	#instVars : [
		'value',
		'alias'
	],
	#category : 'Glorp-Expressions'
}

{ #category : #'instance creation' }
ConstantExpression class >> for: anObject [

	^self new value: anObject
]

{ #category : #accessing }
ConstantExpression >> alias [
	^alias
]

{ #category : #accessing }
ConstantExpression >> alias: anObject [
	alias := anObject
]

{ #category : #preparing }
ConstantExpression >> asExpressionJoiningSource: source toTarget: target [
	"Create a general expression which represents this relationship where the values of the targets (which are normally parameters) are supplied out of the context provided by 'target' and the source fields are referencing things out of the context of source. Produces something suitable for ANDing into an expression when doing a join
   Example: If we had CUSTOMER.ADDRESS_ID = ADDRESS.ID as a parameter, and we want to AND this into an expression [:customer | customer address street = 'Main'] then we have customer as a base, and we get 
	(customer.ADDRESS.STREET = 'Main') AND (customer.CUSTOMER.ADDRESS_ID = customer.ADDRESS.ID)
	The primary key expression for the relationship has been translated into field references into the customer and address tables in a particular context."

	^self.
]

{ #category : #converting }
ConstantExpression >> asGlorpExpressionForDescriptor: aDescriptor [
	"This should only get sent to us if we're the top level of an expression. And since we don't have children, we're also the bottom level. This is only useful for the case where the expression is [:each | true] or [:each | false]."

	^(EmptyExpression on: value)
		rebuildOn: (BaseExpression new descriptor: aDescriptor).
]

{ #category : #converting }
ConstantExpression >> asGlorpExpressionOn: aBaseExpression [
	^self.
]

{ #category : #testing }
ConstantExpression >> canBind [
	"Return true if this represents a value that can be bound into a prepared statement"
	^true.
]

{ #category : #accessing }
ConstantExpression >> canHaveBase [
	"Return true if this type of expression can have a base expression on which other things can be built. Doesn't say whether we actually have a valid one or not."
	^false.
]

{ #category : #accessing }
ConstantExpression >> field [
	^self.
]

{ #category : #api }
ConstantExpression >> get: aSymbol withArguments: anArray [
	| functionExpression |
	functionExpression := self getFunction: aSymbol withArguments: anArray.
	functionExpression isNil ifFalse: [^functionExpression].
	^RelationExpression
		named: aSymbol
		basedOn: self
		withArguments: anArray
]

{ #category : #testing }
ConstantExpression >> isConstantExpression [
	^true.
]

{ #category : #'As yet unclassified' }
ConstantExpression >> mappedFields [
	^Array with: self.
]

{ #category : #printing }
ConstantExpression >> printOnlySelfOn: aStream [

	aStream print: value
]

{ #category : #printing }
ConstantExpression >> printSQLOn: aStream withParameters: aDictionary [
	self value glorpPrintSQLOn: aStream.
]

{ #category : #printing }
ConstantExpression >> printSelectSQLOn: aStream withParameters: aDictionary [
	self value glorpPrintSelectSQLOn: aStream.
	alias notNil ifTrue: [
		aStream 
			nextPutAll: ' AS ';
			nextPutAll: alias].
]

{ #category : #printing }
ConstantExpression >> printTreeOn: aStream [ 
	aStream print: value
]

{ #category : #printing }
ConstantExpression >> printUnqualifiedSQLOn: aStream withParameters: aDictionary [
	self printSQLOn: aStream withParameters: aDictionary.
]

{ #category : #preparing }
ConstantExpression >> rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression [
	^self.
]

{ #category : #'As yet unclassified' }
ConstantExpression >> table [
	^nil.
]

{ #category : #accessing }
ConstantExpression >> ultimateBaseExpression [
	^nil.
]

{ #category : #accessing }
ConstantExpression >> value [
	^value
]

{ #category : #accessing }
ConstantExpression >> value: anObject [
	value := anObject
]

{ #category : #accessing }
ConstantExpression >> valueIn: aDictionary [
	^value
]

{ #category : #mapping }
ConstantExpression >> valueInBuilder: aBuilder [
	^value.
]

{ #category : #'As yet unclassified' }
ConstantExpression >> valueInBuilder: aBuilder as: anExpression [
	^value.
]
