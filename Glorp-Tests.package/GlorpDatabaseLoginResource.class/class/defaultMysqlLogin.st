defaults
defaultMysqlLogin
	"To set the default database login to MySQL, execute the following statement."
	"self defaultMysqlLogin."

	^DefaultLogin := (Login new
		database: MySQLPlatform new;
		host: 'localhost';
		port: '3306';
		databaseName: 'sodbxtest';
		username: 'sodbxtest';
		password: 'sodbxtest')
	
