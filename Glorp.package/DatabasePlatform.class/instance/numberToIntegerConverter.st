conversion-numbers
numberToIntegerConverter
	^DelegatingDatabaseConverter
		named: #numberToInteger
		hostedBy: self
		fromStToDb: #convertToInteger:for:
		fromDbToSt: #convertToInteger:for:.