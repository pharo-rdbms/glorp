accessing
whereClause
	| allCriteria |
	allCriteria := queries inject: #() into: [:sum :each | sum, each whereClause].
	^ExpressionGroup new addAll: allCriteria