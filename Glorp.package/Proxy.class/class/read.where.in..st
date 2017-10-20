*Glorp
read: aClass where: aBlock in: aSession
	^self new
		query: (Query read: aClass where: aBlock);
		session: aSession