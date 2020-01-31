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
	self halt.
	command := self deleteSqlWith: anArray.
	"Should this duplicate the error handling in rowsFromDatabasewithParameters:?"
	session accessor executeCommand: command returnCursor: false.
	^command rowCount.
]

{ #category : #accessing }
ActiveRecordQuery >> session: aSession [
	| table |
	super session: aSession.
	aSession ifNotNil: [  
	table := aSession system tableForClass: self resultClass.
	((table fieldNamed: #deleted_at ifAbsent: [ ] caseSensitive: false) notNil
		and: [ resultClass canUnderstand: #deletedAt ]) 
			ifTrue: [ self AND: [ :ea | ea deletedAt isNIL] ] ]
]
