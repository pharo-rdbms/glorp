This represents an arbitrary sub-select. This would normally get created by embedding a query instance inside a query block. For example
   where: [:each | each id > 2 & (each something = aWholeOtherQuery)].
Warning: This can be get very complicated, especially if aWholeOtherQuery refers to variables inside the main query block, creating a correlated subselect.

Instance Variables:
	query	<Query>	The query that we subselect.

