conditions
trace: aTracing context: anExpression
	"To make a join, we need to look at all of our possible cases"

	conditionalFieldMapping isNil ifFalse: [
		conditionalFieldMapping trace: aTracing context: anExpression].
	cases do: [:each |
		each value trace: aTracing context: anExpression]