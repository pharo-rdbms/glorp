running
setUp
	session := GlorpSessionResource current newSession.
	session system: (AnySatisfyDescrSystem forPlatform: session platform).
	self createTestData: session.