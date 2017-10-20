api
alsoFetch: anExpression 
	"Add the expression as something which will be explicitly retrieved and knit together with other results, but NOT included in the result list"

	self addExpression: anExpression andDo: [:exp |
		alsoFetchExpressions add: exp]