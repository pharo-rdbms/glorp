support
tearDown

	super tearDown.
	session rollbackTransaction.
	session reset.
	session := nil.