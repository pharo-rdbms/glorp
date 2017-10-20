utility
recreateTablesFor: aLogin
	"Drop and recreate the tables for this descriptor system in the given database."

	| session |
	session := self sessionForLogin: aLogin.
	session login.
	[session recreateTables] ensure: [session logout]