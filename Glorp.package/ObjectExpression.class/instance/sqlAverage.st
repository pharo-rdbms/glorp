api-aggregates
sqlAverage
	"Make a subselect of the expression that is our argument, returning an avg(). e.g.
session read: GlorpCustomer where: 	[:each |  each accounts balance sqlAverage > 100]."
	^self queryLevelBaseExpression average: self.