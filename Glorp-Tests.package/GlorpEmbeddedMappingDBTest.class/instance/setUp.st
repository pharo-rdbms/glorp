support
setUp
	super setUp.
	session beginTransaction.
	self writeAgents.
	session reset.