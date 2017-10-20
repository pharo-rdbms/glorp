queries metadata
listTableNamesInSchemaNamed: schemaString

	| databasePlatform sqlStatement result |
	databasePlatform := self currentLogin platform.
	sqlStatement := databasePlatform sqlStatementToListTablesInSchema: schemaString.
	result := self executeSQLString: sqlStatement.
	^result isEmpty
		ifTrue: [#()]
		ifFalse: [result collect: [:ea| ea first]]