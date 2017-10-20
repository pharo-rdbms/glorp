iterating
rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression
	| copy |
	self == anExpression ifTrue: [^aBaseExpression].
	self base == ultimateBaseExpression ifTrue: [^self].
	copy := self copy.
	copy base: aBaseExpression.
	^copy.