conversion-strings
byteArrayToStringConverter
	^DelegatingDatabaseConverter
		named: #byteArrayToString
		hostedBy: self
		fromStToDb: #convertStringToByteArray:for:
		fromDbToSt: #convertByteArrayToString:for:.