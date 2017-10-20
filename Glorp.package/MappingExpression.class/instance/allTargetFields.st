accessing
allTargetFields
	"If we are sending this, then we're treating the expression as a join, for a complex (and probably read-only) relationship. So in that case we want to treat the target fields as being the source fields of the bottom-most mapping. That is, the fields we'll use to connect to the thing we want are the things that our expression's base (which represents the thing we want) would use to connect to the first level mapping arising from it."
	^self penultimateBaseExpression join allSourceFields.