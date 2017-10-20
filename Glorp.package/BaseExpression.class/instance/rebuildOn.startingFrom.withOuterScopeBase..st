preparing
rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression
	anExpression isNil ifTrue: [^aBaseExpression].
	anExpression == self ifTrue: [^aBaseExpression].
	^ultimateBaseExpression isNil ifTrue: [self] ifFalse: [ultimateBaseExpression].