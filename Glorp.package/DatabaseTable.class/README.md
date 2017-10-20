This is our internal representation of a table in the database. It holds onto enough information for us to both map to the table, and to create it in the database if required.

Instance Variables
	fields	<(Collection of: DatabaseField)>	The columns in the table.
	foreignKeyConstraints	<(Collection of: ForeignKeyConstraint)>	The foreign key constraints between this table and others.
	indexes	<(Collection of: DatabaseIndex)>	The indexes on this table.
	isImaginary	<Boolean>	We allow "imaginary" tables, which don't really exist in the database. This is most useful in connection with embedded mappings. For example, we can have a Currency object which maps to a CURRENCY table, but there is no currency table in the database, and instead we have a number of embedded mappings that put those fields inside another table.
	lockKeyFields	<Collection of: DatabaseField>	Which fields (which should also be in our field list) are checked when doing optimistic locking
	name	<String>	The name of the table.
	parent	<DatabaseTable | nil>	For a normal table, this is nil. When we create an aliased table we remember who the original table was using this field.
	primaryKeyFields	<(SequenceableCollection of: (DatabaseField))>	Which fields (which should also be in our field list) are primary keys.
	replacementSubSelect	<CompoundQuery | SimpleQuery>	I honestly don't remember at the moment what this does, but it seems to be used when we're traversing relationships that are in imaginary tables in order to figure out what the actual join has to be. And maybe the join needs to be done in a subselect rather than as a simple join in certain cases.
	schema	<String>	What is the name of the schema in which this table exists. This is used when printing the qualified name of the table. 
	uniqueConstraints	<(Collection of: UniqueConstraint)>	The unique constraints for this table
