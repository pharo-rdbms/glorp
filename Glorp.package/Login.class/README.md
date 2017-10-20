Enough information to log in to a particular database.

Instance Variables:
	connectString	<String>	The string that will be passed to the driver level to tell us what to connect to. This might be e.g. an ODBC data source name, or it might be a host name plus socket/database name for Postgresql.
	database	<DatabasePlatform>	The platform describing what type of database this is. Used here mostly to indicate how we need to talk to the underlying connection layer, which may be different by database.
	name	<String>	A name we can use to describe this. No significance to the database.
	password	<String>	The connect password.
	schema	<String>	What should our default schema be. Used mostly internally, to set the schema of the tables we are using.
	username	<String>	The connect username.

