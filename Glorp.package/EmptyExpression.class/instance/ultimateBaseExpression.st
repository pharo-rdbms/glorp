navigating
ultimateBaseExpression

	base isNil ifTrue: [base := BaseExpression new].
	^base ultimateBaseExpression.