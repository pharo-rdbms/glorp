This is the abstract superclass of builders. These assemble information, either primitive data or objects, from a database result set.

Subclasses must implement the following messages:
	building objects
		buildObjectFrom:
		findInstanceForRow:useProxy:
	selecting fields
		fieldsFromMyPerspective

Instance Variables:
	expression	<MappingExpression>	The expression we're mapping. e.g. if the query is reading people, this might be the expression corresponding to "each address", meaning that we build the address object related to the main Person instance by the given relationship. 
	fieldTranslations	<Array of: Integer>	 The translation of the field positions from where they are in the descriptor to where they are in the row we're reading. This is done so we can read the rows efficiently, by index, rather than doing lots of dictionary lookups by name. If we're doing a simple read, the translations will probably be a no-op, but if we read multiple objects, some of the fields will be in different positions than they are in our table definition.
	instance	<Object>	The thing we're constructing.
	isExpired	<Boolean>	If our instance is in cache, we use that instead. However, if the instance has expired, then we do something different (most likely force a refresh) than if it's still alive.
	key	<Object>	The key for this row. This is lazily computed, and "self" is used a special marker to indicate that it hasn't been computed yet.
	query	<AbstractReadQuery>	the query that we're building results for.
	requiresPopulating	<Boolean>	Do we need to populate the object. Will be false if the object was found in cache and hasn't expired.
	row	<Array>	The database results. May actually be a result set row of some sort rather than an array, depending on the dialect, but should always respond to indexing protocol.

