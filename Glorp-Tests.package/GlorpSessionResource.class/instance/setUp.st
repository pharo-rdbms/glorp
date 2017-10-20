setup
setUp
	super setUp.
	session := self glorpTestsSystem
		sessionForLogin: GlorpDatabaseLoginResource current login.
	self setAccessor.