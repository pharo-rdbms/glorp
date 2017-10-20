This is a command based on one or more in-memory rows. The purposes is to write, or delete that row or rows. This knows enough to be able to use features like array binding to do the row operations more efficiently.

Subclasses must implement the following messages:
	bound values
		arrayBoundFields
		singleRowBoundFields

Instance Variables:
	allRows	<(Collection of: (DatabaseRow))> A collection of rows. May be nil. If we have multiples, then we will be array bound or otherwise bulk-written under certain circumstances.
	row	<DatabaseRow>	The primary row, either the single row we're writing, or the one we're writing right now out of the allRows collection.
	rowCount	<Integer>	The row count from the last statement we executed.
	succeeded	<Boolean>	Has the statement overall succeded or failed.

