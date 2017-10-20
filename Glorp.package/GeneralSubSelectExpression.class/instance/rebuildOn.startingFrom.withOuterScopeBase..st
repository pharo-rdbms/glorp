preparing
rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression
	| rebuiltBase rebuilt |
	self == anExpression ifTrue: [^aBaseExpression].
	rebuiltBase := base rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression.
	rebuilt := self copy.
	rebuilt base: rebuiltBase.
	rebuilt query: (query rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression).
	^rebuilt.
"	^query asGlorpExpressionOn: aBaseExpression."