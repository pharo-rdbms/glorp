accessing
allTablesFor: aDescriptor
	"Return all tables used by this descriptor or its subclasses. For a non-inheritance descriptor, this is the same as tables."
	self subclassResponsibility