This translates between the the general, portable Glorp protocol and whatever needs to be done to access a database in a particular smalltalk dialect. Most of the real work is done in its subclasses.

Subclasses must implement the following messages:
	accessing
		connectionClassForLogin:
	executing
		basicExecuteSQLString:
		externalDatabaseErrorSignal
		rowCount
	login
		loginIfError:
		logout
		showDialog:

Instance Variables:
	connection	<varies>	The underlying database connection
	currentLogin	<Login> The glorp-level login we are using
	logging	<Boolean>	Is logging on or off
	permittedCommands	<Collection of: DatabaseCommand class>	The list of commands we are permitted to use. This allows us to filter commands, indicating that a particular session should only be doing inserts right now, not updates, deletes, or queries. Or that it should only be doing writes, not reads.
	reusePreparedStatements	<Boolean>	Should we try to reuse prepared statements,that have the same SQL, or just re-prepare each time.

