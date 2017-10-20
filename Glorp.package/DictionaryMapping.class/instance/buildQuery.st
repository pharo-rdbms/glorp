mapping
buildQuery
	| keyExpression valueExpression |
	query := super buildQuery.
	keyExpression := self keyExpression.
	valueExpression := self valueExpression.
	query retrieveDictionaryWithKey: keyExpression value: valueExpression.
	^query