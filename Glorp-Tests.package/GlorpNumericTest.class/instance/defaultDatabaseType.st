types
defaultDatabaseType
	"DB2 default precision is only 5, which needs to be increased for this test."

	^self platform isDB2Platform
		ifTrue: [self platform numeric precision: 10]
		ifFalse: [self platform numeric]