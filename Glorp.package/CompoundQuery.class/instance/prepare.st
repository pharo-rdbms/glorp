preparing
prepare
	| |
	queries do: [:each | each session: session].
	queries do: [:each | each prepare].
	ordering isNil ifFalse: [
		ordering := ordering collect: [:each |
			(self expressionBlockFor: each) asGlorpExpressionOn: queries first baseExpression]].
	grouping isNil ifFalse: [grouping := (self expressionBlockFor: grouping) asGlorpExpressionOn: queries first baseExpression]