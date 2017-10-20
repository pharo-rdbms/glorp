conversion-times
timestampConverter
	^DelegatingDatabaseConverter
		named: #timestamp
		hostedBy: self
		fromStToDb: #toTimestamp:for:
		fromDbToSt: #readTimestamp:for:.	"#printTimestamp:for:"