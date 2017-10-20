api-aggregates
sqlMax
	"Make a subselect of the expression that is our argument, returning a max(). e.g.
session read: GlorpCustomer where: 	[:each |  each accounts balance sqlMax = 1]."
	^self queryLevelBaseExpression max: self.