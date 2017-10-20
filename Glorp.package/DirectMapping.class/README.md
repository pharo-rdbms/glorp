This is the simplest type of mapping, it maps directly between an instance variable that holds some "primitive" type, and a field in a database table.

Instance Variables:
	converter	<DatabaseConverter>	The converter used to transform the data into database form and back again. This will be automatically computed based on the types defined, if possible, but for more complex conversions (e.g. booleans into strings in the database) a converter can be explicitly specified.
	field	<DatabaseField | FunctionExpression>	The field to write to. One complication is that (for reading purposes) the field may be a function. So we might have a mapping that reads from the TO_UPPER of some field, or even an aggregate function like MAX.

