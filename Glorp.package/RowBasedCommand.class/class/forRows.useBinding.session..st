*Glorp
forRows: aCollectionOfDatabaseRows useBinding: aBoolean session: aSession
	^(self new)
		allRows: aCollectionOfDatabaseRows;
		row: aCollectionOfDatabaseRows first;
		useBinding: aBoolean;
		session: aSession;
		yourself.