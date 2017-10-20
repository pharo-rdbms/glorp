preparing
rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression
	| expression left |
	self == anExpression ifTrue: [^aBaseExpression].
	"We've swallowed our left child, so we have to unswallow it before rebuilding"
	left := localBase trueBase rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression.
	expression := left 
		get: relation
		withArguments:
			(Array
				with:
					(self rightChildToRebuild rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression)).
	self isOuterJoin ifTrue: [expression beOuterJoin].
	^expression.