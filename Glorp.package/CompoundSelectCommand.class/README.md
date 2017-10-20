This is a select command that uses a number of sub-commands to print multiple queries, and combine them into one for execution. Used in conjunction with compound queries, e.g. using UNION ALL. The query knows what the combination operation is.

Instance Variables:
	commands	<(Collection of: DatabaseCommand)>	The commands we are to print.