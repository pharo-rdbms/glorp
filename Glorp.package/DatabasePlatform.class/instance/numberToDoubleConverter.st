conversion-numbers
numberToDoubleConverter
	^DelegatingDatabaseConverter
		named: #numberToDouble
		hostedBy: self
		fromStToDb: #convertToDouble:for:
		fromDbToSt: #convertToDouble:for:.