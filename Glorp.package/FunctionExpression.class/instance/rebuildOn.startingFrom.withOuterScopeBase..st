preparing
rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression
	| rebuilt |
	self == anExpression ifTrue: [^aBaseExpression].
	rebuilt := (base rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression) getFunction: self symbol withArguments: (self arguments collect: [:each | each rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression]) in: aBaseExpression system.
	rebuilt alias: self alias.
	^rebuilt.