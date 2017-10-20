setUp
setUp
	super setUp.
	session := GlorpSessionResource current newSession.
	connection := session accessor.
	type := self defaultDatabaseType.
	table := self createTypeTestTable.