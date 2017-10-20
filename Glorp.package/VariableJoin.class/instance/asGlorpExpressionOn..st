converting
asGlorpExpressionOn: aBaseExpression
	| copy |
	copy := self copy.
	copy joins: (copy joins collect: [:each | each asGlorpExpressionOn: aBaseExpression]).
	^copy