converting
basicRebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression
	"Rebuild the query, which is part of a subselect expression, into the new context. The only thing that really matters here is that we get correlated subselect pieces inside the query right. The rest is independent of our main expression"
	prepared := false.
	builders := nil.
	base := SubSelectBaseExpression on: (base trueBase rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression).
	whereClause := whereClause asGlorpExpressionOn: base withUltimateBase: ultimateBaseExpression.
	joins := joins collect: [:each | each asGlorpExpressionOn: base withUltimateBase: ultimateBaseExpression].
	ordering isNil ifFalse: [ordering := ordering collect: [:each | each asGlorpExpressionOn: base withUltimateBase: ultimateBaseExpression]].
	grouping isNil ifFalse: [grouping := grouping collect: [:each | each asGlorpExpressionOn: base withUltimateBase: ultimateBaseExpression]].
"	fields := fields collect: [:each | each isGlorpExpression 
		ifTrue: [each asGlorpExpressionOn: base withUltimateBase: ultimateBaseExpression]
		ifFalse: [each]]."
	fields := OrderedCollection new.