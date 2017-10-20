services tables
printSqlStatementToListTablesInSchema: schemaString on: aStream
	"SQLite3 uses a readonly system table "

	aStream
		nextPutAll: 'SELECT name as table_name FROM sqlite_master ';
		nextPutAll: 'WHERE type = ';
		nextPut: $';
		nextPutAll: 'table';
		nextPut: $';
		nextPut: $;