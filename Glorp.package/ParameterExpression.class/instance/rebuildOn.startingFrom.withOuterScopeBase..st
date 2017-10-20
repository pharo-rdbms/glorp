preparing
rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression
	self == anExpression ifTrue: [^aBaseExpression].
	self base == ultimateBaseExpression ifTrue: [^self].
	^aBaseExpression getParameter: lookupKey.