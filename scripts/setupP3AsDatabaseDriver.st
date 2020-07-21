DatabaseAccessor classForThisPlatform DefaultDriver: P3DatabaseDriver.
GlorpDatabaseLoginResource defaultLogin:
  (Login new
		database: PostgreSQLPlatform new;
		username: 'postgres';
		password: 'secret';
		host: 'localhost';
		port: 5432;
		databaseName: 'test';
		yourself)
