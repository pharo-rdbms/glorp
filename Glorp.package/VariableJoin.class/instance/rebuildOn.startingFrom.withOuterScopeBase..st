preparing
rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression
	^(self joins at: aBaseExpression descriptor describedClass) 
		rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression