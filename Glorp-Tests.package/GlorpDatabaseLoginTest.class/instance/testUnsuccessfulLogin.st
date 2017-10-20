tests
testUnsuccessfulLogin

	| anotherAccessor invalidLogin |
	"Some databases can't fail to log in."
	login database supportsAuthentication ifFalse: [^self].

	invalidLogin := GlorpDatabaseLoginResource defaultLogin copy.
	invalidLogin
		password: 'you will never ever guess this password';
		username: 'not a valid user name'.
	anotherAccessor := DatabaseAccessor forLogin: invalidLogin.

	self assert: anotherAccessor isLoggedIn not.
	anotherAccessor loginIfError: [:ex | ].
	self assert: anotherAccessor isLoggedIn not.
	anotherAccessor logout.