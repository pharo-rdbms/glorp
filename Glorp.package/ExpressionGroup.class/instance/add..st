accessing
add: anExpression
	anExpression isNil ifTrue: [^self].
	children add: anExpression.