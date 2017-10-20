support
setUpFolders

	session system: (GlorpCompositeKeyDescriptorSystem forPlatform: session platform).
	session beginTransaction.
	session transact: [session register: session system example1].
	session reset.