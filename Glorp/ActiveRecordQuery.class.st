Class {
	#name : #ActiveRecordQuery,
	#superclass : #SimpleQuery,
	#category : #'Glorp-ActiveRecord'
}

{ #category : #executing }
ActiveRecordQuery >> deleteFromDatabaseWithParameters: anArray [
	| command |
	self descriptor classesRequiringIndependentQueries size >1 ifTrue: [self error: 'Delete with where clause not yet supported for classes that cross tables.'].
	(self class includesBehavior: ActiveRecordQuery) ifTrue: [self error: 'Non-simple queries not yet supported for deletes with where clauses'].
	command := self deleteSqlWith: anArray.
	"Should this duplicate the error handling in rowsFromDatabasewithParameters:?"
	session accessor executeCommand: command returnCursor: false.
	^command rowCount.
]

{ #category : #'initialize-release' }
ActiveRecordQuery >> initResultClass: aClass whereClause: theCriteria singleObject: aBoolean [ 
	| originalExpression amendedExpression |
	resultClass := aClass.
	originalExpression := ((theCriteria isNil or: [theCriteria = true or: [theCriteria = false]]) 
		ifTrue: [EmptyExpression on: theCriteria] ifFalse: [theCriteria]).
	amendedExpression := (aClass instVarIndexFor: #deletedAt ifAbsent: [  ])
		ifNil: [ originalExpression ] 
		ifNotNil: [ [:ea | ea deletedAt isNIL AND: [ originalExpression value: ea ] ] ].
	self whereClause: amendedExpression.
	readsOneObject := aBoolean.
	aBoolean ifTrue: [self limit: 1]
]
