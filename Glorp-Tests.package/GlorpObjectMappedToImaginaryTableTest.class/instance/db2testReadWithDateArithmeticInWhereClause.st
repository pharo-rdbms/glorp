tests
db2testReadWithDateArithmeticInWhereClause
	"DB2 appears fussy in how it allows date arithmetic.  Constant durations must be labelled (i.e. + 2 days, not just + 2, and the root of an expression with a duration must be a date or timestamp.  This could be read to mean that
	dueDate - 2 days - 2 hours
should be OK and
	dueDate - (2 days + 2 hours)
should not be (making it impossible to compute the printing of any multi-part duration expression) but in fact tests suggest that no arrangement of brackets will allow even
	dueDate - 2 days - 2 hours
and we must write only a single labelled duration expression
	dueDate - 2 days
We therefore provide functions for DB2's duration syntax and require users of DB2 to write their clauses to use them;  see DB2Platform>>initializeFunctions."

	| rentals paramKey query |
	Transcript cr; show: 'On DB2, testReadWithDateArithmeticInWhereClause only tests a limited range of date arithmetic.'.
	paramKey := DatabaseField named: #dayNum type: session platform integer.
	query := Query
		read: GlorpVideoRental
		where: [:each | each dueDate + (each parameter: paramKey) days > Date today].
	rentals := query
		executeWithParameters: (Dictionary new at: paramKey put: 1; yourself)
		in: session.
	self deny: rentals isEmpty.
	rentals := session
		read: GlorpVideoRental
		where: [:each | each dueDate + each id days > Date today].
	self deny: rentals isEmpty.