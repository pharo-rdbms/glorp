executing
executeSubQueries: subQueries withParameters: anArray
	^self shouldUseSingleQuery
		ifTrue: [self executeSubQueriesCombined: subQueries withParameters: anArray]
		ifFalse: [self executeSubQueriesIndividually: subQueries withParameters: anArray]