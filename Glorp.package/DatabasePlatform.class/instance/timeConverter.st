conversion-times
timeConverter
	^DelegatingDatabaseConverter
		named: #time
		hostedBy: self
		fromStToDb: #toTime:for:
		fromDbToSt: #readTime:for:.	"#printTime:for:"