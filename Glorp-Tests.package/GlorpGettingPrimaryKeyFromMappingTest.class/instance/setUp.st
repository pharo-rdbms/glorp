support
setUp
	super setUp.
	system := GlorpDocumentDescriptorSystem forPlatform: system platform.
	session system: system.
	session beginTransaction.