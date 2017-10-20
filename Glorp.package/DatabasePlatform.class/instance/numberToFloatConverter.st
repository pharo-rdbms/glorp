conversion-numbers
numberToFloatConverter
	^DelegatingDatabaseConverter
		named: #numberToFloat
		hostedBy: self
		fromStToDb: #convertToFloat:for:
		fromDbToSt: #convertToFloat:for:.