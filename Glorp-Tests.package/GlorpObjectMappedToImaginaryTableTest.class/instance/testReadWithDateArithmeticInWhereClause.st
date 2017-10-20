tests
testReadWithDateArithmeticInWhereClause
	"Test date arithmetic using constant expressions and field expressions.  Trivially, we use the id field to get a positive integer - aim is just to verify the expression runs and returns the rows).
	The rental data is set up and torn down each time the test is run so (ignoring cross-midnight runs) their dates will always be today's date."

	| rentals |
	"Check date +/- integer expressions;  DB2 will not accept this unlabelled, so is tested separately."
	"session platform class == DB2Platform ifTrue:
		[^self db2testReadWithDateArithmeticInWhereClause]."
	session platform supportsArithmeticOperatorsOnDates ifFalse: [ self skip ].
	rentals := session read: GlorpVideoRental where:
		[:each | each dueDate + 1 > Date today].
	self deny: rentals isEmpty.
	rentals := session read: GlorpVideoRental where:
		[:each | each dueDate - (each id + each id) < Date today].
	self deny: rentals isEmpty.