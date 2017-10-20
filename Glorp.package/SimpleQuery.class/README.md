This is a query that is directly executable. A single query might be more than we can do in a single database read, so we might have to break it down into simple queries. But at the moment we just break anything down into an equivalent single query.

Instance Variables:
	builders	<OrderedCollection of: ElementBuilder)>	The builders that will assemble the object from the row that this query returns.
	fields	<OrderedCollection of: DatabaseField>	The fields being selected.
	joins	<OrderedCollection of: Join> While preparing the query, we will need to build up a list of joins implied by the relationships in the where clause, ordering, and so forth. This acts as storage for those.
	tablePrefix	<String>	If we are part of a subselect, we want to prefix all of our table aliases with some known, common prefix, so that we won't have our own t1 which would get confused with the parent query's t1. The normal convention is something like 's1' for subselect 1, so we get s1t1, and so forth.
	command <DatabaseCommand> We can tell the query to use a specific command instead of generating one appropriately. Note that if this is set, it overrides most of the other sql generation.

