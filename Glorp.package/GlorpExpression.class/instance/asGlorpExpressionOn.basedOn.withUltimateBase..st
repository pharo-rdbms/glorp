converting
asGlorpExpressionOn: aBaseExpression basedOn: oldBaseExpression withUltimateBase: ultimateBaseExpression
	^self
		rebuildOn: aBaseExpression
		startingFrom: oldBaseExpression
		withOuterScopeBase: ultimateBaseExpression.