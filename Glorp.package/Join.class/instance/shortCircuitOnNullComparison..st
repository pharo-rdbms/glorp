testing
shortCircuitOnNullComparison: parameters
	"Return true if we represent an expression that compares null to a non-nullable value (in any of our clauses), so we don't ever need to really evaluate it"

	self fieldsDo: [:source :target |
		(target isNullable not and: [(parameters at: source) isNil]) ifTrue: [^true]].
	^false.