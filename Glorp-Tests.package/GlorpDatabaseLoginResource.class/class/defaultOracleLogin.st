defaults
defaultOracleLogin
	"To set the default database login to Oracle, execute the following statement."
	"self defaultOracleLogin."

	^DefaultLogin := (Login new)
		database: OraclePlatform new;
		username: 'System';
		password: 'manager';
		connectString: ''