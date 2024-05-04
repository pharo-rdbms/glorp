"
This represents the null expression, but more polymorphically than just sticking nil in the where clause. We also use this as a short-circuiting mechanism if we're given a where clause that is either just literal true or literal false. So if you end up creating a query with a literal false, we will never go to the database, we'll just return an empty collection as the result. This is more useful than you might think.

Instance Variables:
	base	<GlorpExpression>	Our base expression, which we'll use in case someone ANDs or ORs something onto us.
	value	<Boolean| nil > If we are true or false, then this result may end up being short-circuited. If it's nil, then we're just an empty where clause.


"
Class {
	#name : 'EmptyExpression',
	#superclass : 'GlorpExpression',
	#instVars : [
		'base',
		'value'
	],
	#category : 'Glorp-Expressions',
	#package : 'Glorp',
	#tag : 'Expressions'
}

{ #category : 'instance creation' }
EmptyExpression class >> on: aValue [

	^ self new value: aValue
]

{ #category : 'api' }
EmptyExpression >> AND: anExpression [

	anExpression isNil ifTrue: [ ^ self ].
	^ anExpression asGlorpExpression
]

{ #category : 'api' }
EmptyExpression >> OR: anExpression [

	anExpression isNil ifTrue: [ ^ self ].
	^ anExpression
]

{ #category : 'accessing' }
EmptyExpression >> base [

	^ base
]

{ #category : 'accessing' }
EmptyExpression >> base: aBaseExpression [

	base := aBaseExpression
]

{ #category : 'testing' }
EmptyExpression >> canHaveBase [

	^ true
]

{ #category : 'testing' }
EmptyExpression >> canPrint [
	"Return true if we can print into a where clause"

	^ false
]

{ #category : 'iterating' }
EmptyExpression >> do: aBlock skipping: aSet [
	"Iterate over the expression tree"

	(aSet includes: self) ifTrue: [^self].
	aSet add: self.
	base do: aBlock skipping: aSet.
	aBlock value: self
]

{ #category : 'initialize' }
EmptyExpression >> initialize [

	super initialize.
	value := true
]

{ #category : 'testing' }
EmptyExpression >> isEmptyExpression [

	^ true
]

{ #category : 'accessing' }
EmptyExpression >> isFalse [

	^ value not
]

{ #category : 'accessing' }
EmptyExpression >> isTrue [

	^ value
]

{ #category : 'As yet unclassified' }
EmptyExpression >> printSQLOn: aCommand withParameters: aDictionary [

	^ self
]

{ #category : 'printing' }
EmptyExpression >> printTreeOn: aStream [

	aStream nextPutAll: 'empty expression'
]

{ #category : 'iterating' }
EmptyExpression >> rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression [

	| copy |
	self == anExpression ifTrue: [^aBaseExpression].
	self base == ultimateBaseExpression ifTrue: [^self].
	copy := self copy.
	copy base: aBaseExpression.
	^ copy
]

{ #category : 'As yet unclassified' }
EmptyExpression >> tablesForANSIJoin [

	^#()
]

{ #category : 'navigating' }
EmptyExpression >> ultimateBaseExpression [

	base isNil ifTrue: [ base := BaseExpression new ].
	^ base ultimateBaseExpression
]

{ #category : 'accessing' }
EmptyExpression >> value: aValue [
	"a value is expected to be nil, true, or false. we treat nil as true"
	
	value := aValue isNil ifTrue: [true] ifFalse: [aValue]
]

{ #category : 'testing' }
EmptyExpression >> willPrintAsWhereClause [

	^ false
]
