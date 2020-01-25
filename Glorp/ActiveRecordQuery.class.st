"
I am a subclass of SimpleQuery and act the same except that I prepend the condition deleted_at is null to all my queries if the table being referenced has a field deleted_at.


"
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
	| amendedExpression |
	amendedExpression := (aClass canUnderstand: #deletedAt)
		ifFalse: [ (theCriteria isNil or: [theCriteria = true or: [theCriteria = false]]) 
			ifTrue: [EmptyExpression on: theCriteria] 
			ifFalse: [theCriteria] ] 
		ifTrue: [ 
			(theCriteria isNil or: [theCriteria = true or: [theCriteria = false]])
				ifTrue:[ [:ea | ea deletedAt isNIL ] ]
				ifFalse: [ [:ea | ea deletedAt isNIL AND: [ theCriteria value: ea ] ] ] ].
	super initResultClass: aClass whereClause: amendedExpression singleObject: aBoolean. 
	
]
