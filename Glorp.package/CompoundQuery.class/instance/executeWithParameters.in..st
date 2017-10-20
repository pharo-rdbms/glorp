executing
executeWithParameters: parameterArray in: aSession
	session := aSession.
	^self 
		readFromDatabaseWithParameters: parameterArray