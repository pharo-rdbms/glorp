This is a special variation of a base expression which is used when we know we are a subselect. In some circumstances we'll need to operate with respect to the subselect base, as if we were a standalone query. But sometimes we'll need to know the broader context in which we're living. Having a separate subclass helps us distinguish.

Instance Variables:
	trueBase	<MappingExpression>	The base on which we are built. Note that this doesn't mean this is the overall base expression, in fact it's probably a mapping expression, it's just the thing from which this subselect was built. Presumably the ultimate base expression can be found by following that outer context down, but there could be multiple levels of subselects involved.

