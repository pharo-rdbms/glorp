services tables
printSqlStatementToListTablesInSchema: schemaString on: aStream
	"Not standardized"

	| schema |
	self usesInformationSchema
		ifFalse: [^self subclassResponsibility].

	schema := (schemaString isNil or: [schemaString isEmpty])
		ifTrue: ['']
		ifFalse: [schemaString, '.'].
	aStream
		nextPutAll: 'SELECT TABLE_NAME FROM ' ;
		nextPutAll: schema;
		nextPutAll: 'INFORMATION_SCHEMA.TABLES ';
		nextPut: $;