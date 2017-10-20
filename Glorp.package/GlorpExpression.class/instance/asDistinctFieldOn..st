converting
asDistinctFieldOn: anExpression
	^(self asGlorpExpressionOn: anExpression) get: #distinct withArguments: #().