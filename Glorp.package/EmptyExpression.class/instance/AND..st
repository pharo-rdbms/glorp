api
AND: anExpression

	anExpression isNil ifTrue: [^self].
	^anExpression asGlorpExpression.