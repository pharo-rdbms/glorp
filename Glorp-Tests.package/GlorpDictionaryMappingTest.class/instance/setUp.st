support
setUp
	super setUp.
	session system: (GlorpEncyclopediaDescriptorSystem forPlatform: session platform).
	session beginTransaction.