support
setUp
	super setUp.
	session system: GlorpLockingDescriptorSystem new.
	session beginTransaction.
	session transact: [session register: session system example1].