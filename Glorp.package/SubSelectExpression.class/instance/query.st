accessing
query
	query isNil ifTrue: [self initializeQuery].
	^query.