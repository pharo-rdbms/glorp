api-aggregates
sqlSum
	"Make a subselect of the expression that is our argument, returning a count(*). e.g.
session read: GlorpCustomer where: 	[:each |  each accounts balance sqlSum = 1]."
	^self queryLevelBaseExpression sum: self.