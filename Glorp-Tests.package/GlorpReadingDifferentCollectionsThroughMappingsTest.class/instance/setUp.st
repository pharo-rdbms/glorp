setup
setUp
	super setUp.
	session := GlorpSessionResource current newSession.
	system := self descriptorClass forPlatform: session platform.
	session system: system.
	session beginTransaction.