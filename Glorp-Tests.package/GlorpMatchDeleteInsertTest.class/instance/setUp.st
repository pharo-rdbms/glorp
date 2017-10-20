running
setUp
	super setUp.
	session system: (GlorpDictionaryDescriptorSystem forPlatform: session platform).
	self repopulate.