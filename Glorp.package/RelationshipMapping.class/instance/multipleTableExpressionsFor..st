preparing
multipleTableExpressionsFor: anExpression
	^self referenceDescriptor multipleTableJoin
		collect: [:each | each asExpressionJoiningSource: anExpression toTarget: anExpression]