Class {
	#name : #GlorpFilteringQueryTest,
	#superclass : #TestCase,
	#instVars : [
		'collection'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #tests }
GlorpFilteringQueryTest >> testSimple [

	| query result |
	query := FilteringQuery on: #( 1 2 3 4 5 6 7 8) filter: [:each :parameters | each odd].
	result := GlorpSession new execute: query.
	self assert: result equals: #(1 3 5 7)
]
