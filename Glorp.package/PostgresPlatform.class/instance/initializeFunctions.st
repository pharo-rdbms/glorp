functions
initializeFunctions
	"Postgres supports standard regex and also the ANSI SQL 'SIMILAR TO' form of regex, in which the % and _ of SQL's LIKE predicate replace the corresponding * and ? of regex."

	super initializeFunctions.
	functions at: #similarTo: put: (InfixFunction named: 'SIMILAR TO').
	functions at: #regexMatches: put: (InfixFunction named: '~').