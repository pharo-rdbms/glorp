executing
alterField: aField newType: aType ifError: aBlock

	^self doDDLOperation: [
		self 
			execute: [self executeSQLStringNoResult: 
						(self platform createAlterColumnStatement: aField newType: aType)]
			ifError: aBlock ]