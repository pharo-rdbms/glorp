login
isLoggedIn
	self databaseDriver ifNil: [^ false].
	^ self databaseDriver isConnected