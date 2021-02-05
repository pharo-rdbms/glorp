Class {
	#name : #GlorpExpressionRebuildingTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'original',
		'newBase',
		'rebuilt'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #support }
GlorpExpressionRebuildingTest >> setUp [
	super setUp.
	newBase := BaseExpression new.
]

{ #category : #tests }
GlorpExpressionRebuildingTest >> testLoneBase [
	original := BaseExpression new.
	rebuilt := original rebuildOn: newBase.
	self assert: rebuilt == newBase.
]

{ #category : #tests }
GlorpExpressionRebuildingTest >> testMapping [
	original := [:each | each foo] asGlorpExpression.
	rebuilt := original rebuildOn: newBase.
	self assert: rebuilt base == newBase.
]

{ #category : #'tests-outer scope references' }
GlorpExpressionRebuildingTest >> testRebuildDoubleInnerScopeNormallyWithExists [
	original := [:each | 
	each foo
		anySatisfyExists:
			[:eachFoo | eachFoo things anySatisfyExists: [:eachThing | eachThing stuff = each fooThing]]]
		asGlorpExpression.
	rebuilt := original rebuildOn: newBase.
	rebuilt do: [:each | self assert: each ultimateBaseExpression == newBase].
]

{ #category : #'tests-outer scope references' }
GlorpExpressionRebuildingTest >> testRebuildDoubleInnerScopeNormallyWithJoins [
	original := [:each | 
	each foo
		anySatisfyJoin:
			[:eachFoo | eachFoo things anySatisfyJoin: [:eachThing | eachThing stuff = each fooThing]]]
		asGlorpExpression.
	rebuilt := original rebuildOn: newBase.
	rebuilt do: [:each | self assert: each ultimateBaseExpression == newBase].
]

{ #category : #'tests-outer scope references' }
GlorpExpressionRebuildingTest >> testRebuildInnerScopeForSubquery [

	| foo |
	original := [:each | each foo anySatisfyJoin: [:eachFoo | eachFoo thing = each fooThing]] asGlorpExpression.
	"Just so that it prints distinctively"
	original ultimateBaseExpression descriptor: (Descriptor new classModel: (GlorpClassModel for: Object)).
	foo := original leftChild.
	newBase := SubSelectBaseExpression on: foo.
	rebuilt := original rightChild rebuildOn: newBase startingFrom: foo.
	self assert: rebuilt leftChild base == newBase.
	self assert: rebuilt leftChild ultimateBaseExpression == original ultimateBaseExpression.
	self assert: rebuilt rightChild base == original ultimateBaseExpression.
]

{ #category : #'tests-outer scope references' }
GlorpExpressionRebuildingTest >> testRebuildInnerScopeNormally [
	original := [:each | each foo anySatisfy: [:eachFoo | eachFoo thing = each fooThing]]
		asGlorpExpression.
	rebuilt := original rebuildOn: newBase.
	rebuilt do: [:each | self assert: each ultimateBaseExpression == newBase].
]

{ #category : #'tests-outer scope references' }
GlorpExpressionRebuildingTest >> testRebuildMappingWithStart [

	original := [:each | each foo bar] asGlorpExpression.
	rebuilt := original rebuildOn: newBase startingFrom: original base.
	self assert: rebuilt base == newBase.
]

{ #category : #tests }
GlorpExpressionRebuildingTest >> testRelation [
	original := [:each | each foo bar = each foo bletch] asGlorpExpression.
	rebuilt := original rebuildOn: newBase.
	self assert: rebuilt ultimateBaseExpression == newBase.
	self assert: rebuilt leftChild ultimateBaseExpression == newBase.
	self assert: rebuilt rightChild ultimateBaseExpression == newBase.
	self assert: rebuilt leftChild base base == newBase.
]
