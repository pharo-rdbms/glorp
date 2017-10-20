utility
dropTablesFor: aLogin
	"Drop the tables for this descriptor system in the given database."

	| session |
	session := self sessionForLogin: aLogin.
	session login.
	[session dropTables] ensure: [session logout]