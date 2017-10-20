functions
initializeFunctions
	"The REGEXP operator is a special syntax for the regexp() user function in SQLite. No regexp() user function is defined by default and so use of the REGEXP operator will normally result in an error message. If a application-defined SQL function named 'regexp' is added at run-time, that function will be called in order to implement the REGEXP operator.  (See sqlite.org/lang_expr.html#regexp for details.)"

	super initializeFunctions.
	functions at: #regexMatches: put: (InfixFunction named: 'REGEXP').