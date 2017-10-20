converting
rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression
	"Rebuild the query, which is part of a subselect expression, into the new context. Don't do it if it's not necessary. But if it is necessary, also the copy the query. Otherwise two mappings using the same subselect query will mess each other up."
	self == anExpression ifTrue: [^aBaseExpression].
	self baseExpression ultimateBaseExpression == ultimateBaseExpression ifTrue: [^self].
	^self shallowCopy basicRebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression