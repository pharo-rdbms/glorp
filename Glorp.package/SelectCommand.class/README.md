This represents a SELECT query to the database. This can either be based on a GLORP query, or on a hard-coded SQL string.

Subclasses must implement the following messages:
	accessing
		printSQL

Instance Variables:
	blockFactor	<SmallInteger>	The blocking factor to use for this query. This is most likely to make a difference for these kind of operations, and so is directly settable here.
	parameters	<Dictionary from: DatabaseField to: Object>	The parameters to the query.

