services tables
printSqlStatementToListTablesInSchema: schemaString on: aStream
	"Not standardized"

	| lowerSchema |
	lowerSchema := (schemaString isNil or: [schemaString isEmpty])
		ifTrue: [schemaString]
		ifFalse: [schemaString asLowercase].
	aStream
		nextPutAll: 'SELECT table_name FROM all_tables '.
	(lowerSchema notNil and: [lowerSchema notEmpty]) ifTrue:
		[aStream 
			nextPutAll: 'WHERE lower(owner) = ';
			nextPut: $';
			nextPutAll: lowerSchema;
			nextPut: $']