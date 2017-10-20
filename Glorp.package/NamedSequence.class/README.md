This is a database sequence that is identified by name.

Subclasses must implement the following messages:
	SQL
		tableSelectCommandFor:in:reserving:

Instance Variables:
	name	<String>	The name of the sequence
	schema	<String>	The schema that contains the sequence. Subclasses should set this up appropriately.
	tableSelectCommand	<SQLStringSelectCommand>	The command to execute to get the next value. 

