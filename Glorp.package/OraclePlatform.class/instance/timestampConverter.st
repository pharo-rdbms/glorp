conversion-times
timestampConverter
	^DelegatingDatabaseConverter
		named: #timestamp
		hostedBy: self
		fromStToDb: #asTimestamp:for:
		fromDbToSt: #readTimestamp:for:.