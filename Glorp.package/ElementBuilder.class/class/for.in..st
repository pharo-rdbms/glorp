instance creation
for: anExpression in: aQuery

	^(self classFor: anExpression in: aQuery) new
		expression: anExpression;
		query: aQuery;
		setup