conversion-numbers
numberToDecimalConverter

	^DelegatingDatabaseConverter
		named: #numberToDecimal
		hostedBy: self
		fromStToDb: #convertToDecimal:for:
		fromDbToSt: #convertToDecimal:for:.