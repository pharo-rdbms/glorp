testing
shortCircuitOnNullComparison: parameters
	"Return true if we represent an expression that compares null to a non-nullable value, so we don't ever need to really evaluate it.This could be more sophisticated and test if any part of an ANDed and not NOTed clause does such a comparison. But this will do for the most important cases"

	| value |
	outerJoin ifTrue: [^false].
	value := rightChild valueIn: parameters.
	^(relation == #=
		and: [value isNil and: [leftChild field isNullable not]])