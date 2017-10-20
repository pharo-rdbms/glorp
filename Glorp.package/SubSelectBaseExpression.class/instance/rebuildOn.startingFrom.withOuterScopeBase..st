preparing
rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression
	| newBase |
	anExpression isNil ifTrue: [^aBaseExpression].
	anExpression == self ifTrue: [^aBaseExpression].
	newBase := trueBase rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression.
	"If newBase == self, we've already reached this node on another branch and handled it - nothing more to do."
	newBase == self ifFalse: [self trueBase: newBase].
	^self