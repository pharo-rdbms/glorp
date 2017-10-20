This describes an index in the database. Glorp doesn't use it internally, other than when creating tables in the database.

Instance Variables:
	fields	<(SequenceableCollection of: DatabaseField)>	The set of fields that are to be indexed.
	name	<String>	The name of the index. We will try and generate one based on the table if one is not supplied.

