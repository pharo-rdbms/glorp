executing
populateField: aDatabaseField with: aValue ifError: errorBlock

	self
		executeInDDLOperation: [
			self executeSQLStringNoResult: (self platform sqlStatementToPopulateColumn: aDatabaseField with: aValue) ]
		ifError: errorBlock