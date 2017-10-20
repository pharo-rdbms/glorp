testing
isExistingTable: tableName inSchema: schemaName
	| databasePlatform sqlStatement result targetSchemaName |
	databasePlatform := self currentLogin platform.
	targetSchemaName := databasePlatform supportsInformationSchema
		ifTrue: [schemaName]
		ifFalse: [''].
	sqlStatement := databasePlatform sqlStatementToTestExistenceOfTable: tableName inSchema: targetSchemaName.
	result := self executeSQLString: sqlStatement.
	^result notEmpty
		ifTrue: [result first first > 0]
		ifFalse: [false]