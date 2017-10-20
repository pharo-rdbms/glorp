specifying retrievals
retrieveSum: anExpression
	self tracing retrieve: ((self expressionBlockFor: anExpression) asGlorpExpression get: #sum)