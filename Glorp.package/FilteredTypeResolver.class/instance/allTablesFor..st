accessing
allTablesFor: aDescriptor
	"Return all tables used by this descriptor or its subclasses. Since all our subclasses use a single table, this is the same as for a normal descriptor."
	^aDescriptor tables