DatabaseAccessor classForThisPlatform DefaultDriver: SQLite3Driver.
GlorpDatabaseLoginResource defaultLogin:
  (Login new
		database: UDBCSQLite3Platform new;
		host: SmalltalkImage current imageDirectory fullName;
		databaseName: 'sodbxtestu.db';
    password: '';
		yourself).
