api
retrieve: anExpression 
	"Add the expression as something which will be explicitly retrieved and knit together with other results, and included in the result list"
	self addExpression: anExpression andDo: [:exp |
		retrievalExpressions add: exp]