api
asGlorpExpressionOn: aBaseExpression
	| copy |
	copy := self copy.
	copy base: aBaseExpression.
	copy outerJoin: outerJoin.
	^copy.