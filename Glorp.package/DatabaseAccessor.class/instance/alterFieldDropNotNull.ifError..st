executing
alterFieldDropNotNull: aField ifError: aBlock

	^self doDDLOperation: [
		self 
			execute: [self executeSQLStringNoResult: 
						(self platform createAlterColumnStatementDropNotNull: aField)]
			ifError: aBlock ]