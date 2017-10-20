services tables
printSqlStatementToTestExistenceOfTable: tableName inSchema: schemaString on: aStream
	"This query will test only for tables that the logged on user has access to..  Glorp supports case-preserving creation of tables in SQLServer (see capitalWritingOfTableName) but this tests case-insensitively, compatibly with its polymorphs in this hierarchy."

	| lowerTableName schema |
	lowerTableName := tableName asLowercase.
	schema := schemaString isNil
		ifTrue: ['']
		ifFalse: [schemaString, '.'].
	aStream
		nextPutAll: 'SELECT count(*) FROM ' ;
		nextPutAll: schema;
		nextPutAll: 'INFORMATION_SCHEMA.TABLES ';
		nextPutAll: 'WHERE lower(TABLE_NAME) = ';
		nextPut: $';
		nextPutAll: lowerTableName;
		nextPut: $';
		nextPut: $;