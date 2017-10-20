executing
deleteFromDatabaseWithParameters: anArray
	| command |
	self descriptor classesRequiringIndependentQueries size >1 ifTrue: [self error: 'Delete with where clause not yet supported for classes that cross tables.'].
	self class ~~ SimpleQuery ifTrue: [self error: 'Non-simple queries not yet supported for deletes with where clauses'].
	command := self deleteSqlWith: anArray.
	"Should this duplicate the error handling in rowsFromDatabasewithParameters:?"
	session accessor executeCommand: command returnCursor: false.
	^command rowCount.