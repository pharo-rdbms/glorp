conversion-strings
integerToStringConverter
	^DelegatingDatabaseConverter
		named: #integerToString
		hostedBy: self
		fromStToDb: #integerToString:for:
		fromDbToSt: #stringToInteger:for:.