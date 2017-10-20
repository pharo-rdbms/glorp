services tables
printSqlStatementToTestExistenceOfTable: tableName inSchema: schemaString on: aStream
	" This query will test only for tables that the logged on user has access to... "

	| lowerTableName lowerSchema |
	lowerTableName := tableName asLowercase.
	lowerSchema := schemaString isNil
		ifTrue: [schemaString]
		ifFalse: [schemaString asLowercase].
	aStream
		nextPutAll: 'SELECT count(*) FROM all_tables ';
		nextPutAll: 'WHERE lower(table_name) = ';
		nextPut: $';
		nextPutAll: lowerTableName;
		nextPut: $';
		nextPutAll: ' AND lower(owner) = ';
		nextPut: $';
		nextPutAll: lowerSchema;
		nextPut: $'