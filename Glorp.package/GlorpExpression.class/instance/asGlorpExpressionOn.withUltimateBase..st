converting
asGlorpExpressionOn: anExpression withUltimateBase: aBaseExpression
	"Build the expression, knowing that some parts of it may refer to an outer context based on aBaseExpression. This is primarily useful for subselect blocks"
	^self rebuildOn: anExpression startingFrom: self queryLevelBaseExpression withOuterScopeBase: aBaseExpression.