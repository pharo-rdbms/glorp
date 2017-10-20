specifying retrievals
retrieveMin: anExpression
	self tracing retrieve: ((self expressionBlockFor: anExpression) asGlorpExpression get: #min)