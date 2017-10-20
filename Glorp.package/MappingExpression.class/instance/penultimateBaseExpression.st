navigating
penultimateBaseExpression
	"Return the one from the last base expression in our tree. Useful if we want to find the first mapping involved in the expression"
	self base base isNil ifTrue: [^self].
	^self base penultimateBaseExpression.