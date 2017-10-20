conversion-boolean
booleanToStringTFConverter
	^DelegatingDatabaseConverter
		named: #booleanToString
		hostedBy: self
		fromStToDb: #convertBooleanToTF:for:
		fromDbToSt: #convertTFToBoolean:for:.