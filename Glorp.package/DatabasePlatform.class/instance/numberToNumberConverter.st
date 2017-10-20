conversion-numbers
numberToNumberConverter
	^DelegatingDatabaseConverter
		named: #numberToNumber
		hostedBy: self
		fromStToDb: #convertToNumber:for:
		fromDbToSt: #convertToNumber:for:.