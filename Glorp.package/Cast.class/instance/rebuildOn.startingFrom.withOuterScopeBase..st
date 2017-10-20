preparing
rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression
	^super rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression.
"	| rebuilt |
	self == anExpression ifTrue: [^aBaseExpression].
	rebuilt := (base rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression).
	rebuilt := self class value: base as: arguments first.
	rebuilt alias: self alias.
	^rebuilt."