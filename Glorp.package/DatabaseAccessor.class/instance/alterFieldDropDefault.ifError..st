executing
alterFieldDropDefault: aField ifError: aBlock

	^self doDDLOperation: [
		self 
			execute: [self executeSQLStringNoResult: 
						(self platform createAlterColumnStatementDropDefault: aField)]
			ifError: aBlock ]