bound values
singleRowBoundFields
	"Return the list of fields to be bound in the SQL string we will use for a single operation. We only need to include those fields that actually have values in the particular row we're operating on"
	self subclassResponsibility.