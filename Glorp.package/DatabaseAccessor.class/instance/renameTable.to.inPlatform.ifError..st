executing
renameTable: aDatabaseTable to: newTableName inPlatform: aDatabasePlatform ifError: errorBlock

	| sqlStatement |
	sqlStatement := aDatabasePlatform sqlStatementToRenameTable: aDatabaseTable to: newTableName.	
	self
		executeInDDLOperation: [ self executeSQLStringNoResult: sqlStatement ]
		ifError: errorBlock