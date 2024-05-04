"
This represents a function that prints postfix, meaning its name comes after its argument. For example, DESC for a descending sort. That's maybe stretching the definition of a function, but that's how it's implemented for purposes of Glorp SQL definition.

"
Class {
	#name : 'PostfixFunction',
	#superclass : 'FunctionExpression',
	#category : 'Glorp-Expressions',
	#package : 'Glorp',
	#tag : 'Expressions'
}

{ #category : 'printing' }
PostfixFunction >> printSQLOn: aStream withParameters: aDictionary [

	base printSQLOn: aStream withParameters: aDictionary.
	self printsIntoJoins ifFalse: [^self].
	aStream nextPutAll: ' '; nextPutAll: function
]

{ #category : 'printing' }
PostfixFunction >> printUnqualifiedSQLOn: aStream withParameters: aDictionary [

	base printUnqualifiedSQLOn: aStream withParameters: aDictionary.
	aStream nextPutAll: ' '; nextPutAll: function
]
