executing
alterField: aField setDefault: anObject ifError: aBlock

	^self doDDLOperation: [
		self 
			execute: [self executeSQLStringNoResult: 
						(self platform createAlterColumnStatement: aField setDefault: anObject )]
			ifError: aBlock ]