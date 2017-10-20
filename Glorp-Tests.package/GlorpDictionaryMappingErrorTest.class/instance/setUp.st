support
setUp
	super setUp.
	session system: (GlorpEncyclopediaStockDescriptorSystem forPlatform: session platform).
	session beginTransaction.