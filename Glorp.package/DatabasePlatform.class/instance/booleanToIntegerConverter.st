conversion-boolean
booleanToIntegerConverter
	^DelegatingDatabaseConverter
		named: #booleanToInteger
		hostedBy: self
		fromStToDb: #convertBooleanToInteger:for:
		fromDbToSt: #convertIntegerToBoolean:for:.