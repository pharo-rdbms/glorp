This is an expression representing a placeholder for a parameter value. So, e.g. object attribute = <parameter for field OWNER_ID>. This is most frequently used for the queries in proxies, although it can be used anywhere. The parameter can be identified by either a field, a name, or an index, which can get fairly ugly.

Instance Variables:
	base	<GlorpExpression>	Our base expression.
	lookupKey	<DatabaseField | SomethingElse>	The thing based on which we look up our parameter value in the array or dictionary of parameters that's passed to the query. So it can be number (for positional usage), a field, or something else.

. 