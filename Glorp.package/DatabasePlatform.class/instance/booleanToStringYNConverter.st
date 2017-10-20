conversion-boolean
booleanToStringYNConverter
	^DelegatingDatabaseConverter
		named: #booleanToString
		hostedBy: self
		fromStToDb: #convertBooleanToYN:for:
		fromDbToSt: #convertYNToBoolean:for:.