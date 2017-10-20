This is a special sort of relation expression used when printing subselects that are generated out of anySatisfy: or noneSatisfy: using an EXISTS/NOT EXISTS clause.

Instance Variables:
	localBase	<SubSelectBaseExpression>	The base expression that our sub-query is built on, as opposed to the overall base expression of query.
	query	<SimpleQuery>	The sub-query we are responsible for.

