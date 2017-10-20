specifying retrievals
retrieveMax: anExpression
	self tracing retrieve: ((self expressionBlockFor: anExpression) asGlorpExpression get: #max)