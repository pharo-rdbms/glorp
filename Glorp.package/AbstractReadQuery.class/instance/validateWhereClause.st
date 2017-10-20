executing
validateWhereClause
	resultClass glorpCanHaveDescriptorDirectly ifFalse: [self error: 'Invalid result class for query'].
	whereClause isJoin ifFalse: [
		whereClause do: [:each | each validate]].
	tracing isNil ifTrue: [^self].
	tracing allTracings do: [:eachTracing |
		eachTracing do: [:eachExpressionNode | eachExpressionNode validate]].