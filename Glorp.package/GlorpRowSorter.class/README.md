This sorts a set of rows to determine the order in which they should be inserted into the database. It does this using a breadth first topological sort. What that means is that instead of traversing the graph depth first, as is normal for topological, we traverse it breadth first. This gives us the desirable property of keeping the child rows together as much as possible. Since the initial input will already have been sorted by the static table ordering that is implied by the foreign key constraints, this will also keep rows from the same table together, unless the sort algorithm finds a reason the order needs to be changed. This maximizes the opportunities for using optimizations like Oracle array binding, which want to write groups of similar rows all at once. Note that we can't just use the table order directly, because there may be row-level issues. That is, rows may need to be written before other rows in the same table, or even if there is a table constraint, it may only be relevant for a small number of rows.

Instance Variables:
	childCache	<IdentityDictionary from: Object to: Collection>	The calculation of children may be expensive, and may have to be done more than once for an item, so we cache the information here.
	childSelector	<Symbol | BlockClosure>	The zero-argument selector which we perform on an item, or the one-argument block which we evaluate in order to get the children.
	current	<DatabaseRow | GlorpBreadthFirstTopologicalSortItem>	The item we are currently examining.
	items	<ReadStream>	A stream on the items we are intended to sort.
	queue	<OrderedCollection>	This maintains the breadth first order. So, when we encounter an item, we add its children to the end of the queue. The Sorter processes the items in order off the queue, resulting in a breadth first traversal.
	sorted	<OrderedCollection>	The resulting collection, in sorted order.

