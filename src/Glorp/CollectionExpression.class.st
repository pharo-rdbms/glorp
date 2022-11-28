"
This represents expressions on collection objects taking a block, which at the moment means just anySatisfy:

We treat this as a relation, but with the special properties that when we convert the right hand side into an expression we assume it's a block and give it a base which is the left-hand side. Also, we don't print this relation when printing SQL, we just print the right hand side.
"
Class {
	#name : #CollectionExpression,
	#superclass : #RelationExpression,
	#category : 'Glorp-Expressions'
}

{ #category : #iterating }
CollectionExpression >> do: aBlock skipping: aSet [
	"Because our argument is a block, and the thing passed to it is our left child, we can assume that our left child will be referenced via that block. So we'll ignore it. This will help when condensing out primary key expressions, because otherwise us iterating over them forces them to stay around."
	| |
	(aSet includes: self) ifTrue: [^self].
	aSet add: self.
	rightChild do: aBlock skipping: aSet.
	aBlock value: self.
]

{ #category : #'printing SQL' }
CollectionExpression >> printSQLOn: aStream withParameters: aDictionary [ 
	"Don't print the left child or ourselves, just the expression that is the right side.
e.g. aPerson addresses anySatisfy: [:each | each city='Ottawa'] prints as
where (address.city = 'Ottawa')
The relation 'aPerson addresses' will ensure that the join gets printed"
	rightChild printSQLOn: aStream withParameters: aDictionary.
]
