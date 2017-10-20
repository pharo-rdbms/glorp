conversion-boolean
booleanToBooleanConverter
	^DelegatingDatabaseConverter
		named: #booleanToBoolean
		hostedBy: self
		fromStToDb: #convertBooleanToDBBoolean:for:
		fromDbToSt: #convertDBBooleanToBoolean:for:.