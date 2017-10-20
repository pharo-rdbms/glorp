executing
executeWithParameters: parameterArray in: aSession 
	| |
	session := aSession.
	self requiresFullQuery 
		ifTrue: [^self asFullQuery executeWithParameters: parameterArray in: aSession].
	self checkValidity.
	self setUpExpressions.
	self checkCacheWithParameters: parameterArray ifPresent: [:hit | session register: hit. ^hit].
	self setupTracing.
	^self 
		readFromDatabaseWithParameters: parameterArray