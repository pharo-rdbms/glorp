tests
testSecureLoginDiscardsPassword
	| oldValue |
	self assert: self accessor isLoggedIn not.
	oldValue := self accessor currentLogin secure.
	[self accessor currentLogin secure: true.
	self accessor login.
	self assert: accessor currentLogin password isNil.
	self accessor logout]
		ensure: [self accessor currentLogin secure: oldValue].