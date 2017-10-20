*Glorp
readOneOf: aClass where: aBlock in: aSession
	^self new
		query: (Query readOneOf: aClass where: aBlock);
		session: aSession.