defaults
defaultLogin
	"Return the default Login. Whether it binds is determined by UseBindingIfSupported if that is set, otherwise by the login platform's preference."

	DefaultLogin isNil ifTrue: [^DefaultLogin := self defaultPostgreSQLLogin].
	DefaultLogin database useBinding: DefaultLogin database class useBindingIfSupported.
	^DefaultLogin