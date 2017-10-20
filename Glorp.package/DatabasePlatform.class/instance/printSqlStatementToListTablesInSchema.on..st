services tables
printSqlStatementToListTablesInSchema: schemaString on: aStream
	" Not standardized, although SQL Server, MySQL and PostgreSQL use the INFORMATION_SCHEMA "

	| lowerSchema |
	self usesInformationSchema
		ifFalse: [^self subclassResponsibility].

	lowerSchema := schemaString isNil
		ifTrue: [schemaString]
		ifFalse: [schemaString asLowercase].
	aStream
		nextPutAll: 'SELECT table_name FROM information_schema.tables ';
		nextPutAll: 'WHERE table_type = ';
		nextPut: $';
		nextPutAll: 'BASE TABLE';
		nextPut: $'.
	(lowerSchema notNil and: [lowerSchema notEmpty])
		ifTrue: [
			aStream
				nextPutAll: ' AND lower(table_schema) = ';
				nextPut: $';
				nextPutAll: lowerSchema;
				nextPut: $'.].
	aStream nextPut: $;