setup
setUp
	super setUp.
	session := GlorpSessionResource current newSession.
	connection := session accessor.