preparing
rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression
	| rebuilt newArgs |
	self == anExpression ifTrue: [^aBaseExpression].
	base == aBaseExpression ifTrue: [^self].
	newArgs := arguments collect: [:each | each rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression].
	rebuilt := (base rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression) get: self symbol withArguments: newArgs.
	rebuilt alias: self alias.
	^rebuilt.