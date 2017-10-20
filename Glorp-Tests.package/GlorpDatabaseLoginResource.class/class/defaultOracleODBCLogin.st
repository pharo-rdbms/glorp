defaults
defaultOracleODBCLogin
	"To set the default database login to Oracle, execute the following statement."
	"self defaultOracleODBCLogin."

	^DefaultLogin := (Login new)
		database: OracleODBCPlatform new;
		username: 'System';
		password: 'manager';
		connectString: 'oracle'