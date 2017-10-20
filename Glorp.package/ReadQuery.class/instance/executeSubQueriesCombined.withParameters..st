executing
executeSubQueriesCombined: subQueries withParameters: anArray
	"Execute out sub queries as a single query with a UNION ALL between the sub-queries. Then select from the results the one which has a value for that row. Used for horizontal inheritance queries."
	| combinedQuery |
	combinedQuery := CompoundQuery newUnionAll.
	self copyAttributesTo: combinedQuery.
	combinedQuery requiresDistinct: false.
	subQueries 	do: 	[:eachQuery | 
		combinedQuery addQuery: eachQuery].
	^combinedQuery executeWithParameters: anArray in: session