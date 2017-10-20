instance creation
basicFor: anExpression in: aQuery

	^(self basicClassFor: anExpression in: aQuery) new
		expression: anExpression;
		query: aQuery;
		setup