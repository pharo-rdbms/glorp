support
setUp
	super setUp.
	system := GlorpVideoDescriptorSystem forPlatform: session platform.
	session system: system.
	session beginTransaction.
	example := system exampleStore1.
	example2 := system exampleStore2.
	session inUnitOfWorkDo: [session register: example. session register: example2.].
	session reset.