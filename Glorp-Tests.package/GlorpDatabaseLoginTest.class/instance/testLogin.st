tests
testLogin
	self assert: self accessor isLoggedIn not.
	self accessor login.
	self assert: self accessor isLoggedIn.
	self accessor logout.
	self assert: self accessor isLoggedIn not