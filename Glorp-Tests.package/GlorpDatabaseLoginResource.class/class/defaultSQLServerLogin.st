defaults
defaultSQLServerLogin
	"To set the default database login for Dolphin, execute the following statement."
	"self defaultSQLServerLogin."

	^DefaultLogin := (Login new)
		database: SQLServerPlatform new;
		username: 'glorptest';
		password: 'password';
		connectString: 'glorptest'