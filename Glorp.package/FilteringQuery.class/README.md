This is a query that expects all the objects it might return to already be in memory, and in a collection from which it can pick them out by evaluating a block. This is used to implement filtered reads on a mapping. When one of the mappings fires, it reads all the relevant results, and so each instance  using that mapping can get the results out of memory without going to the database again.

Instance Variables:
	collectBlock	<Block>	A one-argument block we evaluate to actually collect up the results. That is, internally we are likely to have a more complex representation in the collection, e.g. an array containing various extra information plus the objects. This gets the objects out of the collection.
	collection	<(GlorpVirtualCollection of: Object)>	The collection on which we filter. Typically a virtual collection, at least for filtered reads, but can also handle a normal collection.
	filter	<Block>	The two-argument block we use to filter. The first argument is the entry from the collection, the second is the parameters to the query that were used.
	readsOneObject	<Boolean>	A duplicate of readsOneObject in AbstractReadyQuery. Do we return a collection, or a single result.

