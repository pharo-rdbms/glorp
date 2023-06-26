Class {
	#name : #GlorpTracingTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'tracing'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #running }
GlorpTracingTest >> setUp [

	super setUp.
	tracing := Tracing new.
	tracing setup
]

{ #category : #tests }
GlorpTracingTest >> testAddDuplicateTracings [

	| all |
	tracing addExpression: (tracing base get: #foo).
	tracing addExpression: (tracing base get: #foo).
	all := tracing allTracings.
	self assert: all size equals: 2.
	self assert: all first identicalTo: tracing base
]

{ #category : #tests }
GlorpTracingTest >> testAddRecursiveTracings [

	| all |
	tracing addExpression: (tracing base get: #foo).
	tracing addExpression: ((tracing base get: #foo) get: #bar).
	all := tracing allTracings.
	self assert: all size equals: 3.
	self assert: all first identicalTo: tracing base.
	self assert: all last base identicalTo: (all at: 2)
]

{ #category : #tests }
GlorpTracingTest >> testAddTracing [

	| all |
	tracing addExpression: (tracing base get: #foo).
	all := tracing allTracings.
	self assert: all size equals: 2.
	self assert: all first identicalTo: tracing base.
	self assert: all last identicalTo: (tracing base get: #foo)
]

{ #category : #tests }
GlorpTracingTest >> testAddTwoTracings [

	tracing addExpression: (tracing base get: #foo).
	tracing addExpression: (tracing base get: #bar).
	self assert: tracing allTracings size equals: 3.
	self assert: tracing allTracings first identicalTo: tracing base
]
