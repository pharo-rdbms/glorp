api-aggregates
sqlMin
	"Make a subselect of the expression that is our argument, returning a minimum. e.g.
session read: GlorpCustomer where: 	[:each |  each accounts balance sqlMin = 1]."
	^self queryLevelBaseExpression min: self.