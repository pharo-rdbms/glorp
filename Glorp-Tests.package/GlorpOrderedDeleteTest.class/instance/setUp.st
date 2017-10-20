running
setUp
	super setUp.
	session system: (GlorpOrderedLinkDescriptorSystem forPlatform: session platform).
	session beginTransaction.
	session inUnitOfWorkDo:
		[session register: (GlorpTravelFolder new name: 'Test')].