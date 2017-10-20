services tables
printSqlStatementToTestExistenceOfTable: tableName inSchema: schemaString on: aStream
	" Not standardized, although SQL Server, MySQL and PostgreSQL use the INFORMATION_SCHEMA "

	| lowerTableName lowerSchema |
	self usesInformationSchema
		ifFalse: [^self subclassResponsibility].

	lowerTableName := tableName asLowercase.
	lowerSchema := schemaString isNil
		ifTrue: [schemaString]
		ifFalse: [schemaString asLowercase].
	aStream
		nextPutAll: 'SELECT count(*) FROM information_schema.tables ';
		nextPutAll: 'WHERE lower(table_name) = ';
		nextPut: $';
		nextPutAll: lowerTableName;
		nextPut: $'.
	(lowerSchema notNil and: [lowerSchema notEmpty])
		ifTrue: [
			aStream
				nextPutAll: ' AND lower(table_schema) = ';
				nextPut: $';
				nextPutAll: lowerSchema;
				nextPut: $'.].
	aStream
		nextPutAll: ' AND table_type = ';
		nextPut: $';
		nextPutAll: 'BASE TABLE';
		nextPut: $';
		nextPut: $;