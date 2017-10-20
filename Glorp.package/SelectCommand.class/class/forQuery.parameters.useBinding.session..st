*Glorp
forQuery: aQuery parameters: aDictionary useBinding: aBoolean session: aSession
	^(self new)
		query: aQuery;
		parameters: aDictionary;
		useBinding: aBoolean;
		session: aSession;
		yourself.