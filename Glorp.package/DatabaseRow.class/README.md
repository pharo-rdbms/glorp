This represents the data to be written out to a row. Database rows are normally stored in a rowmap, keyed according to their table and the object that did the primary writes to them. We expect that that's only one object, although embedded values are an exception to that.

Instance Variables:

	table	<DatabaseTable>	The table holding the data
	contents	<IdentityDictionary>	Holds the fields with their values, indirectly through FieldValueWrapper instances.
	shouldBeWritten	<Boolean>	Normally true, but can be set false to suppress writing of a particular row. Used with embedded value mappings, where we create their row, unify it with the parent row, and suppress writing of the original row.
	owner	<Object>	The primary object that wrote into this row, would also be the key into the rowmap.
	forDeletion <Boolean> Is this row to be deleted or written.
	status <Symbol> Used for topological sort to determine write order. We keep a symbol indicating the "visited" status of the row while doing the sort. This doesn't separate the sort from the row, using each row directly as a node in the graph. This is less general, but uses less memory than other alternatives.
	parent <DatabaseRow> Also used during sorting. Keep track of our parent node.
	oldVersion <DatabaseRow> The old version of us. Used if we increment a version field to keep track of what its value was before.
	generated <Boolean> True if we have already had field with generated types generated in the preWrite phase. This is needed because we generate all sequences before doing any writes. But if we use an explicit writeRow: operation, then we want to make sure that generated values are generated. And some generated types write over what was there before (e.g. optimistic lock fields). So we need a way of knowing if generation has already been done. Note that this doesn't apply if using post-write sequence generation (i.e. identity columns) because then it's all after the write. This makes certain things not work as well, but that's what you get for using identity columns.
	