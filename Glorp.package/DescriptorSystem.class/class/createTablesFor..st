utility
createTablesFor: aLogin
	"Create the tables for this descriptor system in the given database. This will fail if the tables already exist. Use recreateTables for that."

	| session |
	session := self sessionForLogin: aLogin.
	session login.
	[session createTables] ensure: 
		[session logout]