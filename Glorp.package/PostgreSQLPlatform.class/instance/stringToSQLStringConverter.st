conversion-strings
stringToSQLStringConverter

	^DelegatingDatabaseConverter
		named: #stringToSQLString
		hostedBy: self
		fromStToDb: #convertByteArrayToSQLString:for:
		fromDbToSt: #convertSQLStringToString:for:.