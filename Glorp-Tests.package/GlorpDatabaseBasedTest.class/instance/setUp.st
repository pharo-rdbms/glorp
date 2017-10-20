support
setUp
	system := GlorpDemoDescriptorSystem forPlatform: GlorpDatabaseLoginResource defaultLogin database.
	system session: GlorpMockSession new.
	system session system: system.