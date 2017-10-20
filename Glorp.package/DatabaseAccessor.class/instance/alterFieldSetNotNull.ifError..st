executing
alterFieldSetNotNull: aField ifError: aBlock

	^self doDDLOperation: [
		self 
			execute: [self executeSQLStringNoResult: 
						(self platform createAlterColumnStatementSetNotNull: aField)]
			ifError: aBlock ]