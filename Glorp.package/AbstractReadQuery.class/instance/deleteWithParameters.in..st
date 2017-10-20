executing
deleteWithParameters: parameterArray in: aSession 
	| |
	session := aSession.
	self checkValidity.
	self setUpExpressions.
	self setupTracing.
	^self deleteFromDatabaseWithParameters: parameterArray.