Class {
	#name : #GlorpTracingTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'tracing'
	],
	#category : 'Glorp-Tests-Tests'
}

{ #category : #support }
GlorpTracingTest >> setUp [

	tracing := Tracing new.
	tracing setup.
]

{ #category : #tests }
GlorpTracingTest >> testAddDuplicateTracings [

	| all |
	tracing addExpression: (tracing base get: #foo).
	tracing addExpression: (tracing base get: #foo).
	all := tracing allTracings.
	self assert: all size = 2.
	self assert: all first == tracing base.
]

{ #category : #tests }
GlorpTracingTest >> testAddRecursiveTracings [

	| all |
	tracing addExpression: (tracing base get: #foo).
	tracing addExpression: ((tracing base get: #foo) get: #bar).
	all := tracing allTracings.
	self assert: all size = 3.
	self assert: all first == tracing base.
	self assert: all last base == (all at: 2).
]

{ #category : #tests }
GlorpTracingTest >> testAddTracing [

	| all |
	tracing addExpression: (tracing base get: #foo).
	all := tracing allTracings.
	self assert: all size = 2.
	self assert: all first == tracing base.
	self assert: all last == (tracing base get: #foo).
]

{ #category : #tests }
GlorpTracingTest >> testAddTwoTracings [

	tracing addExpression: (tracing base get: #foo).
	tracing addExpression: (tracing base get: #bar).
	self assert: tracing allTracings size = 3.
	self assert: tracing allTracings first == tracing base.
]
