This is an abstract superclass for Glorp queries.

Subclasses must implement the following messages:
	accessing
		readsOneObject
	executing
		executeWithParameters:in:

Instance Variables:
	collectionType	<Class>	What sort of collection should this query return its results in.
	expectedRows	<Integer>	Roughly how many rows should we expect to get back. Doesn't have to be right, but can be used to set buffer sizes appropriately in the database.
	ordering	<(SequenceableCollection of: (GlorpExpression | Block | Symbol))>	If we order the results, what are the ordering criteria. Either an expression, but one whose root ends up evaluating to a field, or a block or symbol that can be converted to same.
	prepared	<Boolean>	Has this query already been prepared (at the Glorp level), this says nothing about prepared statements for the database, which will be separate objects.
	session	<GlorpSession>	What session should this query execute in. Can be nil until we start to prepare the query.
