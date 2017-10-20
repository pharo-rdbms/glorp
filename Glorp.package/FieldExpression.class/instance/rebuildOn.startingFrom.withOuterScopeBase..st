As yet unclassified
rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression
	| result |
	self == anExpression ifTrue: [^aBaseExpression].
	result := (base rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression) getField: field.
	result alias: self alias.
	^result.