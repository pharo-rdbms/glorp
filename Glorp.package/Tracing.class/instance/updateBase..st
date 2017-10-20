setup
updateBase: aBaseExpression
	"Make sure we have the same base as the query"
	| transformed |
	transformed := IdentityDictionary new.
	base == aBaseExpression ifTrue: [^self].
	base := aBaseExpression.
	allTracings := allTracings collect: [:each | | new | new := each asGlorpExpressionOn: base.
		transformed at: each put: new.
		new].
	retrievalExpressions := retrievalExpressions collect: [:each | 
		transformed at: each].
	alsoFetchExpressions := alsoFetchExpressions collect: [:each | 
		transformed at: each]