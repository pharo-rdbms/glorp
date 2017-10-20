accessing
allSourceFields
	"If we are sending this, then we're treating the expression as a join, for a complex (and probably read-only) relationship. So in that case we want to treat the source fields as the parameters that this expression takes, and specifically the parameters that are based on fields."
	^self inject: OrderedCollection new into: [:sum :each |
		each addToTargetFields: sum.
		sum].