bound values
arrayBoundFields
	"Return the list of fields to be bound in the SQL string we will use for array binding. For array binding, we need to include all possible fields, rather than those that just have values in a particular row"
	self subclassResponsibility.