login
logout
	self isLoggedIn ifFalse: [^self].
	self log: 'Logout'.
	self databaseDriver logout.
	self log: 'Logout finished'