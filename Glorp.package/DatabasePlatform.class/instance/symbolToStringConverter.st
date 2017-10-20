conversion-strings
symbolToStringConverter
	^DelegatingDatabaseConverter
		named: #symbolToString
		hostedBy: self
		fromStToDb: #symbolToString:for:
		fromDbToSt: #stringToSymbol:for:.