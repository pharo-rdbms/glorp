conversion-strings
stringToStringConverter
	^DelegatingDatabaseConverter
		named: #stringToString
		hostedBy: self
		fromStToDb: #padString:for:
		fromDbToSt: #unpadString:for:.