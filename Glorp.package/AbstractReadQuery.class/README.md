An abstract superclass for Glorp queries. Most query types will descend from this, but a couple are specialized.

Subclasses must implement the following messages:
	executing
		rowsFromDatabaseWithParameters:

Instance Variables:
	base	<BaseExpression>	In Glorp expressions it's very important that expressions we're trying to compose together are built on the same base, which represents the object that we're talking about in the query. This holds the base expression that we're expecting to use in this query.
	limit	<Integer>	Some databases support limiting the number of rows retrieved. If we can, we'll use this variable to set that.
	offset	<Integer>	Some databases support starting from a given point in the collection of retrievable rows, often used in combination with limit. So, e.g. get me the rows, sorted by name, starting at the 1012th and giving me 40 of them.
	proxyType	<Class | nil>	If this is nil, do not use proxies. Otherwise, use this class to create proxies for relationships. At the moment, likely to be either Proxy or TimedProxy.
	readsOneObject	<Boolean>	Do we return only one object, or a collection. That is, is this a readManyOf: or a readOneOf:
	resultClass	<Behavior>	What kind of objects are we looking for.
	shouldRefresh	<Boolean>	If the result is already in cache, should we refresh it according to what the database says, or just return it as is.
	tracing	<Tracing>	The tracing. This describes the graph of objects we will actually retrieve.
	whereClause	<GlorpExpression>	What is the criteria on which we will filter the results.

