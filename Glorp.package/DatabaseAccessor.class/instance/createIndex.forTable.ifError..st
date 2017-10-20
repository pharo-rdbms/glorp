executing
createIndex: aGlorpDatabaseIndex forTable: aGlorpDatabaseTable ifError: aBlock
	self 
		execute:
			[self executeSQLStringNoResult:
				(self platform 
					createTableIndexStatementStringFor: aGlorpDatabaseTable
					index: aGlorpDatabaseIndex)]
		ifError: aBlock.