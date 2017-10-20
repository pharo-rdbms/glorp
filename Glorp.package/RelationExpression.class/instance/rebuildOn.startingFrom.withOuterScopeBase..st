preparing
rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression
	| expression |
	self == anExpression ifTrue: [^aBaseExpression].
	expression := (leftChild rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression)
		get: relation
		withArguments:
			(Array
				with:
					(self rightChildToRebuild rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression)).
	self isOuterJoin ifTrue: [expression beOuterJoin].
	^expression.