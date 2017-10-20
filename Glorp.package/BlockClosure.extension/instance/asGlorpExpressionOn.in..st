*Glorp-Core
asGlorpExpressionOn: anExpression in: aQuery 
	^(self value: (MessageArchiver new privateGlorpQuery: aQuery)) asGlorpExpressionOn: anExpression.