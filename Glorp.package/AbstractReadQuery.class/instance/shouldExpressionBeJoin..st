preparing
shouldExpressionBeJoin: anExpression
	"Return true if the expression should be a join in our context (which means it refers only to tables we have in our from list) or if it should be ANDed into the where clause). Only relevant if we're using ANSI joins"
	^anExpression
		allSatisfy:
			[:eachNode | 
			| queryBase |
			queryBase := eachNode queryLevelBaseExpression.
			queryBase isNil or: [	queryBase = self baseExpression]]