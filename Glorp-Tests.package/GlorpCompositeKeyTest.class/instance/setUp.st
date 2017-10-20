setup
setUp
	super setUp.
	system := (GlorpCompositeKeyDescriptorSystem forPlatform: session platform).
	session system: system.
	session beginTransaction.
	session transact: [session register: system example1].
	session reset.