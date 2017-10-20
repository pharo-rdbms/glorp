This is a superclass for objects that convert back and forth between database representations and object representations.

Subclasses must implement the following messages:
	converting
		convert:fromDatabaseRepresentationAs:
		convert:toDatabaseRepresentationAs:

Instance Variables:
	name	<ByteSymbol>	The name for this converter. The name is used, concatenated with #Converter, to create a symbol that can be performed against the DatabasePlatform to give this converter. So, e.g. booleanToIntegerConverter.

