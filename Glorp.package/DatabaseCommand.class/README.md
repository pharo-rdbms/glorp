A DatabaseCommand is what a query uses to actually generate its SQL and to execute it. A command wraps a stream, into which the SQL is written, but with knowledge of the platform for which it's being written, and potentially details about how it should execute.

Subclasses must implement the following messages:
	accessing
		arrayBoundFields
		bindings
		bindingTypes
		parameterTypeSignature
	executing
		printSQL
	testing
		succeeded

Instance Variables:
	platform	<DatabasePlatform>	The database for which we're to generate/execute SQL.
	sqlString	<String>	The resulting SQL.
	stream	<Stream>	The stream into which we generate the SQL. Once we've finished and got sqlString this isn't necessary any more.
	useBinding	<Boolean>	Should we use binding, or print parameters directly into the string.

