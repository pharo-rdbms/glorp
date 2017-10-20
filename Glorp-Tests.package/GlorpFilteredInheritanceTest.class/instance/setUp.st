support
setUp
	super setUp.
	session := GlorpSessionResource current newSession.
	session system: (GlorpInheritanceDescriptorSystem forPlatform: GlorpDatabaseLoginResource defaultLogin database).