This represents a database function or other modifier. For example, conversion to upper or lower case, or the ascending/descending modifier in order by clauses. At the moment it is hard-coded to to handle only the descending modifier and does not handle e.g. function arguments, functions that differ between databases, functional syntax ( as opposed to postfix). One would probably define subclasses to handle these cases, but this is the simplest thing that could possibly work for the current functionality.

Instance Variables
	function	<String>	The string we print to the database
	base <GlorpExpression> The thing we're a function of.
	alias <String> If we're to be selected as a field, what should we be selected as. Think SELECT t1.A + t1.B AS FRED.
	symbol <Symbol> The original symbol used to create us. Helpful if recreating onto a different platform where the DB string can be different.
	type <GlorpDatabaseType> Optional. If we have a type defined, then we can record it here. Otherwise, we will return the type of the field we are operating on.
	
