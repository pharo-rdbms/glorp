executing
copyDataFromTable: fromTable toTable: anotherTable ifError: errorBlock

	self
		executeInDDLOperation: [ self executeSQLStringNoResult: (self platform sqlStatementToCopyDataFromTable: fromTable to: anotherTable) ]
		ifError: errorBlock