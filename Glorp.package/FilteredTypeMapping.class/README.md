FilteredTypeMapping assumes that all objects are stored in a single table, and there's a field in that table that identifies which subclass it is.

Instance Variables:
	field	<DatabaseField>	The field which identifies the subclass.
	key	<Object>	The value we expect to find in that field for this particular subclass
	keyDictionary	<Dictionary>	A dictionary for us and all of our subclasses from key values to subclass.

