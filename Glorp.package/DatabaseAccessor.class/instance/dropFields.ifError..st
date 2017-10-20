executing
dropFields: aCollection ifError: aBlock

	aCollection
		do: 	[:aField | 
			self execute: [self executeSQLStringNoResult: (self platform createDropColumnStatementFor: aField)]
				ifError: aBlock ].