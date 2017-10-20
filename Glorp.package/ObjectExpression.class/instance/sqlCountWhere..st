api-aggregates
sqlCountWhere: filterExpression
	"Make a subselect of the expression that is our argument, returning a count(). e.g.
session read: GlorpCustomer where: 	[:each |  each accounts sqlCount = 1]."
	^self queryLevelBaseExpression count: self where: filterExpression.