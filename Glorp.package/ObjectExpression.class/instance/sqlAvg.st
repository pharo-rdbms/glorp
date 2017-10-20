api-aggregates
sqlAvg
	"Make a subselect of the expression that is our argument, returning an avg(). e.g.
session read: GlorpCustomer where: 	[:each |  each accounts balance sqlAvg > 100]."
	^self queryLevelBaseExpression average: self.