AdHocMapping is a configurable sort of mapping, done via two blocks. It's not easy to use, but gives you very direct access to the underlying mechanisms, so it should be possible to write mappings that are otherwise very complicated or impossible.

Instance Variables:
	fromDbMappingBlock	<BlockClosure>	The block we invoke when reading from the database. It's given arguments of the "row" we got from the database (note that this doesn't necessarily correspond to a single row, but is all the fields we selected in the query) , the elementBuilder associated with our containing object, and the "context", the expression from the query for what we're reading from the database. Typical usage is to use the context to translate a field into the appropriate aliased field from the query, and use the element builder to get the value of that field. e.g. elementBuilder valueOfField: (context translateField: someField) in: row
	mappedFields	<SequenceableCollection of: DatabaseField>	The list of fields we work with. We need to specify this so that Glorp knows that it needs to e.g. includes these fields in the list of those selected.
	shouldProxy	<Boolean>	Should we create a proxy for our target objects when we read an object containing this mapping.
	toDbMappingBlock	<BlockClosure>	The block we invoke when writing to the database. It takes as arguments the rowmap being created, the target object we are writing, and a dictionary of the rows we already have associated with this object. The block is expected to update the rowmap with the new information.

