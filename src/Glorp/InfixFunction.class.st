"
This is a function that is infix. That is, it prints its name in between its arguments. For example, + for string concatenation, || for logical OR. 

Instance Variables:
	arguments	<Collection of GlorpExpression>	Our post-arguments (the first one being the base).
	functionParts <Array of: String> The parts of our name. For a two-argument function, this is just the same as an array containing the name, but for one with more (e.g. BETWEEN AND) it contains the different portions of the name.

"
Class {
	#name : 'InfixFunction',
	#superclass : 'FunctionExpression',
	#instVars : [
		'argument',
		'arguments',
		'functionParts'
	],
	#category : 'Glorp-Expressions',
	#package : 'Glorp',
	#tag : 'Expressions'
}

{ #category : 'instance creation' }
InfixFunction class >> named: aStringOrArray [
	| instance trimmedName |
	instance := self new.
	aStringOrArray isString
		ifTrue: [instance function: aStringOrArray]
		ifFalse: [
			instance functionParts: aStringOrArray.
			trimmedName := aStringOrArray copyFrom: 2 to: aStringOrArray size.
			instance function: (trimmedName inject: aStringOrArray first into: [:sum :each | sum, ' ', each])].
	^instance
]

{ #category : 'accessing' }
InfixFunction >> argument [

	^ arguments first
]

{ #category : 'accessing' }
InfixFunction >> argument: anObject [

	arguments := Array with: anObject
]

{ #category : 'accessing' }
InfixFunction >> arguments [

	^ arguments
]

{ #category : 'accessing' }
InfixFunction >> arguments: anArray [

	arguments := anArray
]

{ #category : 'preparing' }
InfixFunction >> asExpressionJoiningSource: source toTarget: target [
	"Create a general expression which represents this relationship where the values of the targets (which are normally parameters) are supplied out of the context provided by 'target' and the source fields are referencing things out of the context of source. Produces something suitable for ANDing into an expression when doing a join
   Example: If we had CUSTOMER.ADDRESS_ID = ADDRESS.ID as a parameter, and we want to AND this into an expression [:customer | customer address street = 'Main'] then we have customer as a base, and we get
	(customer.ADDRESS.STREET = 'Main') AND (customer.CUSTOMER.ADDRESS_ID = customer.ADDRESS.ID)
	The primary key expression for the relationship has been translated into field references into the customer and address tables in a particular context."

	| newArguments |
	newArguments := arguments collect: [:each | each asExpressionJoiningSource: source toTarget: target].
	^(super asExpressionJoiningSource: source toTarget: target) arguments: newArguments
]

{ #category : 'converting' }
InfixFunction >> asField [
	"If we correspond to a single field, return it. This is a bit of a hack having this only here, because for some functions it doesn't work."

	^ self
]

{ #category : 'iterating' }
InfixFunction >> do: aBlock skipping: aSet [
	"Iterate over the expression tree. Keep track of who has already been visited, so we don't get trapped in cycles or visit nodes twice."

	(aSet includes: self) ifTrue: [ ^ self ].
	super do: aBlock skipping: aSet.
	arguments do: [ :each | each do: aBlock skipping: aSet ]
]

{ #category : 'accessing' }
InfixFunction >> functionParts [

	functionParts isNil ifTrue: [ functionParts := Array with: function ].
	^ functionParts
]

{ #category : 'accessing' }
InfixFunction >> functionParts: anArray [

	functionParts := anArray
]

{ #category : 'printing' }
InfixFunction >> printSQLOn: aStream withParameters: aDictionary [

	| translated |
	base printSQLOn: aStream withParameters: aDictionary.
	self printsIntoJoins ifFalse: [^self].
	1 to: self functionParts size do: [:i |
		aStream
			nextPut: $ ;
			nextPutAll: (self functionParts at: i);
			nextPut: $ .
		i > arguments size ifFalse: [
			translated := self convertValueOf: (arguments at: i) in: aDictionary.
			translated isGlorpExpression
				ifTrue: [translated printSQLOn: aStream withParameters: aDictionary]
				ifFalse: [self type print: translated on: aStream]]]
]

{ #category : 'printing' }
InfixFunction >> printTreeOn: aStream [

	base printOn: aStream.
	aStream nextPutAll: ' ' , function , ' '.
	arguments printOn: aStream
]

{ #category : 'printing' }
InfixFunction >> printUnqualifiedSQLOn: aStream withParameters: aDictionary [

	base printUnqualifiedSQLOn: aStream withParameters: aDictionary.
	self functionParts with: arguments do: [:functionPart :arg |
		aStream
			nextPut: $ ;
			nextPutAll: functionPart;
			nextPut: $ .
		arg printUnqualifiedSQLOn: aStream withParameters: aDictionary]
]

{ #category : 'preparing' }
InfixFunction >> rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression [

	| rebuilt newArgs |
	self == anExpression ifTrue: [^aBaseExpression].
	base == aBaseExpression ifTrue: [^self].
	newArgs := arguments collect: [:each | each rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression].
	rebuilt := (base rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression) get: self symbol withArguments: newArgs.
	rebuilt alias: self alias.
	^ rebuilt
]
