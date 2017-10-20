This is an abstract superclass for relationships between one mapped object and another (or a collection of others).

Instance Variables:
	join	<Join>	The join between our table and the target. Note that if we use a link table, this will be a join between our table and the link table.
	targetTableJoin	<Join>	If we're using a link table, it may be desirable to also join to attributes of the main table. This optional extra join allows that.

	query	<SimpleQuery>	The query that will return the other side of the relationship, given parameters describing our side.
	linkFields	<Collection of: DatabaseField>	When there's a link table, we need to know the other side of the relationship, from link table to target. Usually we can figure it out based on the target table and the foreign key constraints, but sometimes (e.g. if there are multiple relationships to the same table) we need to be told which fields are the ones that connect to this table. Again that's FROM the LINK table TO the TARGET table, not the entry in the link table that we'd connect  to.
	reverseJoin	<Join>	caches the other end of the relationship, as above.
	rowMapKeyConstructorBlock	<BlockClosure>	Usually row map keys are constructed automatically, but it's possible that in weird cases we  might need to construct complicated ones (e.g. if there are 3 things that need to participate instead of just two, as in Store's use of the same link table and the same row to indicate the relationship from package to class and package to metaclass).
	shouldProxy	<Boolean>	Should we proxy or directly construct the referenced object
	shouldUseFilteredRead	<Boolean>	should we use a filtered read.
	usesLinkTable	<Boolean>	Do we use a link table, or is it a direct join to the target.
	isExclusive <Boolean> Is this an exclusive relationship - so that when the parent object is deleted, the child or children will also be deleted.

