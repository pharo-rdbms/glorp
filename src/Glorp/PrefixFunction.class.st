"
This represents a function which prints prefix, printing its name, followed by the arguments in parentheses. This is the most common sort of function, e.g. MIN(), MAX(), DISTINCT, TO_CHAR 

Instance Variables:
	arguments	<(SequenceableCollection of: GlorpExpression)>	Our arguments (in addition to our base).
	separator	<String>	What we will use to separate the arguments. By default, a comma.


"
Class {
	#name : #PrefixFunction,
	#superclass : #FunctionExpression,
	#instVars : [
		'arguments',
		'separator',
		'argumentModifierBlock'
	],
	#category : 'Glorp-Expressions'
}

{ #category : #accessing }
PrefixFunction >> argumentModifierBlock [
	^argumentModifierBlock
]

{ #category : #accessing }
PrefixFunction >> argumentModifierBlock: aBlock [
	argumentModifierBlock := aBlock
]

{ #category : #accessing }
PrefixFunction >> arguments [
	^arguments.
]

{ #category : #accessing }
PrefixFunction >> arguments: aCollection [
	"Our arguments may have already been set to a block, in which case we evaluate it with the incoming collection."
	argumentModifierBlock notNil ifTrue: [^arguments := argumentModifierBlock value: self value: aCollection].
	arguments := aCollection.
]

{ #category : #converting }
PrefixFunction >> convertedStValueOf: anObject [
	"This assumes that functions that do conversions have already had their effect in the database, and all we're concerned with is the fundamental data type conversion"
	^base convertedStValueOf: anObject.
]

{ #category : #iterating }
PrefixFunction >> do: aBlock skipping: aSet [
	"Iterate over the expression tree. Keep track of who has already been visited, so we don't get trapped in cycles or visit nodes twice."

	(aSet includes: self) ifTrue: [^self].
	aSet add: self.
	base do: aBlock skipping: aSet.
	arguments do: [:each | each do: aBlock skipping: aSet].
	aBlock value: self.
]

{ #category : #initializing }
PrefixFunction >> initialize [
	super initialize.
	arguments := #().
	separator := ','.
]

{ #category : #printing }
PrefixFunction >> printBasicSQLOn: aStream withParameters: aDictionary forSelect: aBoolean [
	aStream
		nextPutAll: function;
		nextPut: $(.
	aBoolean
		ifTrue: [base printSelectSQLOn: aStream withParameters: aDictionary]
		ifFalse: [base printSQLOn: aStream withParameters: aDictionary].
	arguments
		do:
			[:each | 
			"It's possible there needs to be type conversion here similar to InfixFunction>>printSQLOn:withParameters:, but it's not clear how common that case is, or how best to do it, so leaving it until it becomes a problem."
			aStream nextPutAll: separator.
			aBoolean 
				ifTrue: [each printSelectSQLOn: aStream withParameters: aDictionary]
				ifFalse: [each printSQLOn: aStream withParameters: aDictionary]].
	aStream nextPut: $).
	alias notNil
		ifTrue:
			[aStream
				nextPutAll: ' AS ';
				nextPutAll: alias].
]

{ #category : #printing }
PrefixFunction >> printSQLOn: aStream withParameters: aDictionary [
	self printsIntoJoins
		ifTrue: [self printBasicSQLOn: aStream withParameters: aDictionary forSelect: false]
		ifFalse: [base printSQLOn: aStream withParameters: aDictionary].
]

{ #category : #printing }
PrefixFunction >> printSelectSQLOn: aStream withParameters: aDictionary [
	self printBasicSQLOn: aStream withParameters: aDictionary forSelect: true.
]

{ #category : #printing }
PrefixFunction >> printTreeOn: aStream [ 
	aStream
		nextPutAll: function, '('.
	base printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #accessing }
PrefixFunction >> separator [
	^separator
]

{ #category : #accessing }
PrefixFunction >> separator: aString [
	separator := aString
]
