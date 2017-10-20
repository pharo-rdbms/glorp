This is a converter which delegates the conversion to methods on some other object, typically the database platform.

Instance Variables
	host	<Object>	The receiver of the methods specified by the selectors.
	dbToStSelector	<Symbol>	The symbol we perform when converting from database to object representation. Takes two arguments, the value, and the database type.
	stToDbSelector	<Symbol>	The symbol we perform when converting from object to database representation. Takes two arguments, the value, and the database type.

