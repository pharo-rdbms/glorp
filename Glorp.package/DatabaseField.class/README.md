This represents a field in a database table. See also DatabaseTable. Glorp relies heavily on identity of fields for comparison purposes, so be careful when copying these.

Instance Variables:
	defaultValue	<Object>	What is the default value of this field, if unspecified in the creation statement.
	isLockKey	<Boolean>	Is this field part of an optimistic lock key. If so, then on update we will generate an update statement that checks that this value hasn't changed since the object wasn't read.
	isNullable	<Boolean>	Is this field allowed to be null?
	isPrimaryKey	<Boolean>	Is this field part of the primary key?
	isUnique	<Boolean>	Does this field have a unique constraint in the database?
	name	<String>	The name of the field.
	position	<Object | ProtoObject>	description of position
	table	<DatabaseTable>	The table that contains this field.
	type	<GlorpDatabaseType>	The type of  data that this field contains.

