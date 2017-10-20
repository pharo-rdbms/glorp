testing
shortCircuitOnNullComparison: anObject
	"Return true if we represent an expression that compares null to a non-nullable value, so we don't ever need to really evaluate it"

	^false.