conversion-boolean
booleanToStringYesNoConverter
	^DelegatingDatabaseConverter
		named: #booleanToString
		hostedBy: self
		fromStToDb: #convertBooleanToYesNo:for:
		fromDbToSt: #convertYesNoToBoolean:for:.