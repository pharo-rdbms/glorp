logging
logOnly

	logOnly ifNil: [logOnly := false].
	^logOnly and: [self logging]