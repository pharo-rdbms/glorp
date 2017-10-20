A tracing is a collection of expressions representing the graph of other objects which
are to be read at the same time as the root object.

Instance Variables:

	base	<Expression>	The base expression representing the root object. Same as the parameter to the query block
	allTracings	<Collection of: Expression>	The expressions representing each of the associated objects. e.g. base accounts, base amount serviceCharge .
	alsoFetchExpressions	<(Collection of: GlorpExpression)>	Objects to also retrieve, but not included in the result set, just knitted together with the other related objects.
	retrievalExpressions	<(Collection of: GlorpExpression)>	Objects to also retrieve, and to include in the result set

