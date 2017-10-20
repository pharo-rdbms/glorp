api-aggregates
sum: anExpression
	"Make a subselect of the expression that is our argument, returning a sum. e.g.
session read: GlorpCustomer where: 	[:each |  (each sum: [:eachCust | eachCust accounts id]) > 5]."
	^self aggregate: anExpression as: #sum.