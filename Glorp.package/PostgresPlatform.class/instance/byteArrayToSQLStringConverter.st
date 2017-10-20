conversion-strings
byteArrayToSQLStringConverter

	^DelegatingDatabaseConverter
		named: #byteArrayToSQLString
		hostedBy: self
		fromStToDb: #convertByteArrayToSQLString:for:
		fromDbToSt: #convertSQLStringToByteArray:for:.