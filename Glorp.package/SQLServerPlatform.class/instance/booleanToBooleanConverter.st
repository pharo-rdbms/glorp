conversion-boolean
booleanToBooleanConverter
	^DelegatingDatabaseConverter
		named: #booleanToBoolean
		hostedBy: self
		fromStToDb: #convertBooleanToInteger:for:
		fromDbToSt: #convertDBBooleanToBoolean:for:.