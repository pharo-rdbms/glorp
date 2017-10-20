running
setUp
	super setUp.
	system := TESTDescriptorSystem forPlatform: session platform.
	session system: system.