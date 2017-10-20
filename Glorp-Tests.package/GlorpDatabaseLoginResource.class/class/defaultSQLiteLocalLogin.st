defaults
defaultSQLiteLocalLogin
	"To set the default database login to SQLite, change the connectString to an appropriate path and execute the following statement."
	"self defaultSQLiteLocalLogin."

	<loginType: 'sqlite3'>

	^DefaultLogin := (Login new)
		database: SQLite3Platform new;
		host: SmalltalkImage current imagePath asFileReference parent fullName, '/';
		port: '';
		username: '';
		password: '';
		databaseName: 'sodbxtest.db'.
