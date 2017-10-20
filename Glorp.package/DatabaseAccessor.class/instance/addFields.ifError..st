executing
addFields: aCollection ifError: aBlock

	aCollection
		do: 	[:aField | 
			self execute: [self executeSQLStringNoResult: (self platform createAddColumnStatementFor: aField)]
				ifError: aBlock ].