This is the normal class to use for select queries. It generates SQL for a select operation returning a set of rows.

Instance Variables:
	boundExpressions	<(Collection of: GlorpExpression)>	The expressions for which we need bind parameters. We expect that these are things that resolve to fields, or more generally, to something the database will accept as a valid thing to bind ofr.
	query	<Query>	The query in which we're executing.

