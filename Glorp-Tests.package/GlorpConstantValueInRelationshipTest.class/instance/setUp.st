support
setUp
	system := GlorpWorkerDescriptorSystem forPlatform: GlorpDatabaseLoginResource defaultLogin database.
	session := GlorpSessionResource current newSession.
	session system: system.