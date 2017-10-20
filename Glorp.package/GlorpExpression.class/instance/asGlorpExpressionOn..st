converting
asGlorpExpressionOn: aBaseExpression
	aBaseExpression ultimateBaseExpression == self ultimateBaseExpression
		ifTrue: [^self].
	^self rebuildOn: aBaseExpression.