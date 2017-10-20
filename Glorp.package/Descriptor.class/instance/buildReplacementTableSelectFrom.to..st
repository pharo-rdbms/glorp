internal
buildReplacementTableSelectFrom: sourceMapping to: targetMapping
	"Build a select statement that combines the two mappings. We expect that both are relationships from a single object whose table is imaginary, so we need to knit together the information from the mappings to join the real tables directly together."

	| fullJoin targetJoin sourceJoin subQuery join |
	subQuery := Query read: sourceMapping referenceClass.
	subQuery session: self session.	
	subQuery setUpExpressions.
	"Invert because these will both start with the imaginary one on the left and we want to merge them together"
	sourceJoin := (sourceMapping join
		replacing: self primaryTable
		withEquivalenceFrom: targetMapping join) inverseJoin.
	targetJoin := targetMapping join
		replacing: self primaryTable
		withEquivalenceFrom: sourceMapping join.
	fullJoin := sourceJoin = targetJoin
		ifTrue: [sourceJoin]
		ifFalse: [sourceJoin , targetJoin].
	join := fullJoin asGeneralGlorpExpression asExpressionJoiningSource: subQuery baseExpression toTarget: subQuery baseExpression.
	subQuery addJoin: join.
	sourceMapping usesLinkTable ifTrue: [subQuery addJoin: (sourceMapping  expressionFromLinkToReferenceTableWithBase: subQuery baseExpression)].
	targetMapping usesLinkTable ifTrue: [subQuery addJoin: (targetMapping  expressionFromLinkToReferenceTableWithBase: subQuery baseExpression)].
	self
		setRetrievalExpressionsInReplacementTableForQuery: subQuery
		fromMapping: sourceMapping
		toMapping: targetMapping.
	^subQuery.