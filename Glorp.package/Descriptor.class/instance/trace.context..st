tracing
trace: aTracing context: anExpression
	"For each mapping, check if the relationship is involved in the set of things
to be read"
	mappings do: [:each |
		each trace: aTracing context: anExpression]