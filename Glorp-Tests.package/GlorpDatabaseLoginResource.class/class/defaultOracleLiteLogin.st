defaults
defaultOracleLiteLogin
	"To set the default database login to Oracle, execute the following statement."
	"self defaultOracleLiteLogin."

	^DefaultLogin := (Login new)
		database: OraclePlatform new;
		username: 'System';
		password: 'password';
		connectString: 'odbc:polite'