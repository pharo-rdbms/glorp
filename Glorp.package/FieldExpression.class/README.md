This is an expression representing a field in a table. It could be used, for example, if we were writing a data level expression.
   getTable: 'foo') getField: 'bar'

Instance Variables:
	alias	<Object>	Sometimes in queries we want to retrieve values in columns other than what they are normally named. So we can give the field an alias, and generate something like "select id, name as somethingElse"
	base	<GlorpExpression>	The expression this is based on, which ought to be something which is associated with the table that contains our field.
	field	<DatabaseField>	The field we represent in the expression.

