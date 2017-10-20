This is an abstract superclass for classes that provide a compatibility layer for different databases. They encapsulate different SQL syntaxes, binding mechanism, types that are available, and general limits.

Subclasses must implement the following messages:
	accessing
		vwEXDIConnectionClass
	binding
		bindingsForGroupWritingFor:
	constants
		areSequencesExplicitlyCreated
		supportsMillisecondsInTimes
	sequences
		databaseSequenceClass
	testing
		usesArrayBindingRatherThanGrouping
	types
		int4
		sequence
		serial
		timestamp
		varbinary
		varchar

Instance Variables:
	characterEncoding	<ByteSymbol>	What character encoding should we use for the database connection.
	converters	<Dictionary from: Symbol to: DatabaseConverter>	The available type converters. So, for example, if there is a boolean to integer conversion, we expect it in this dictionary associated with the symbol #booleanToInteger. If that symbol isn't there, we will look up the converter by performing #booleanToIntegerConverter and caching the result.
	functions	<FunctionExpression>	Which functions are available for this database. There is a set of common functions created by FunctionExpression, plus we can define our own additions or overrides that are specific to this database.
	reservedWords	<Collection of: String>	Which names are reserved words in this database. Any that we use as table or column names will need to be quoted.
	types	<Dictionary from: Symbol to: GlorpDatabaseType>	A cache of available types, mapped by name to the type instance.
	useBinding	<Boolean>	By default, should we use binding for this database.

