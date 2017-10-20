executing
renameField: aDatabaseField to: nameString ifError: errorBlock

	self
		executeInDDLOperation: [ self executeSQLStringNoResult: (self platform sqlStatementToRenameColumn: aDatabaseField to: nameString) ]
		ifError: errorBlock