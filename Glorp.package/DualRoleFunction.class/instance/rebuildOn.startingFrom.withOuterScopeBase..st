preparing
rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression
	| rebuilt |
	self == anExpression ifTrue: [^aBaseExpression].
	"Rebuilding just one of them will rebuild our whole structure, since it all comes from the same definition."
	rebuilt := whereClauseVersion rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression.
	rebuilt == whereClauseVersion ifTrue: [^self].

	rebuilt arguments: (self arguments collect: [:each | each rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression]).
	^rebuilt.