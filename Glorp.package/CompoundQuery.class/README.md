This is a query that has more than one subquery, combined by expressions like UNION ALL or INTERSECTION. It doesn't do all that much except print its subqueries and combine them according to the operation.

Instance Variables:
	operation	<String>	The name of the operation we are using to combine the queries.
	primaryQuery	<Query>	The first query that we contain. This determines what objects we actually return. All of the queries should match up in terms of what they return, or the database is unlikely to accept this as a valid query.
	queries	<(SequenceableCollection of: SimpleQuery)>	The queries we contain.
	specialBuilders <Array of: ElementBuilder> If we want to do something to modify our result, we can add our own set of builders here, which will be added to those of the internal queries. Motivating example is doing a horizontal inheritance query, where we can end up with one of N different objects in the row, and we just want to return that one directly.

