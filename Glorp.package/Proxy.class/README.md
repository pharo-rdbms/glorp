This implements the Glorp database proxy behaviour, for proxies that get their result by evaluating a query using a particular set of parameters, in the context of a particular Glorp query.

Instance Variables:
	parameters	<Dictionary | SequenceableCollection>	Our parameters, keyed either by name or by index.
	query	<Query>	The query we will evaluate. Note that for a mapping, all proxies will share the same query instance.
	session	<GlorpSession>	The session in which this proxy exists, and against which the query will be executed to find our value.

