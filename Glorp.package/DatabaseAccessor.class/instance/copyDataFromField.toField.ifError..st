executing
copyDataFromField: fromField toField: toField ifError: errorBlock

	self
		executeInDDLOperation: [ self executeSQLStringNoResult: (self platform sqlStatementToCopyDataFromColumn: fromField to: toField )]
		ifError: errorBlock