api-aggregates
count: anExpression
	"Make a subselect of the expression that is our argument, returning a count(*). e.g.
session read: GlorpCustomer where: 	[:each |  (each count: [:eachCust | eachCust accounts]) = 1]."
	^self aggregate: anExpression as: #countStar.