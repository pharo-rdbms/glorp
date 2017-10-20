support
tearDown
	session isNil ifFalse: [session reset. session resetPermissions].
	session := nil.
	super tearDown.