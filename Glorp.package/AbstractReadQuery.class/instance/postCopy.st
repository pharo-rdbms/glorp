copying
postCopy
	super postCopy.
	base := BaseExpression new.
	whereClause := whereClause asGlorpExpressionOn: base.
	session isNil ifFalse: [self setUpExpressions].