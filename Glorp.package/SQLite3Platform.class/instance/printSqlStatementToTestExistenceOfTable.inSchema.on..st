services tables
printSqlStatementToTestExistenceOfTable: tableName inSchema: schemaString on: aStream
	"SQLite3 uses a readonly system table and doesn't support schemas, as far as I know"

	| lowerTableName |
	lowerTableName := tableName asLowercase.
	aStream
		nextPutAll: 'SELECT count(*) FROM sqlite_master ';
		nextPutAll: 'WHERE lower(name) = ';
		nextPut: $';
		nextPutAll: lowerTableName;
		nextPut: $';
		nextPutAll: ' AND type = ';
		nextPut: $';
		nextPutAll: 'table';
		nextPut: $';
		nextPut: $;