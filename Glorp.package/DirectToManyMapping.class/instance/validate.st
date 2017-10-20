validation
validate
	super validate.
	"We have to write the order field. Otherwise, we get confused e.g. on deletion, because we don't have a way of telling the rows in the rowmap apart when the indexes have changed"
	(self readOnly not and: [shouldWriteTheOrderField not]) ifTrue: [self error: 'To-many mappings to simple types must write an order field so that we have some way to tell the rows apart'].

	"If we're for a pseudo-variable, we're neither reading nor writing, so we don''t need the order."
	self isForPseudoVariable ifTrue: [^self].
	orderBy isNil ifTrue: [self error: 'To-many mappings to simple types must specify and write an order field so that we have some way to tell the rows apart'].