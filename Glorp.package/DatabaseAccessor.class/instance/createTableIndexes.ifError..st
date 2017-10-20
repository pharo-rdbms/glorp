executing
createTableIndexes: aGlorpDatabaseTable ifError: aBlock 
	"Create all indexes for this table"

	self execute: 
			[(self platform createTableIndexStatementStringsFor: aGlorpDatabaseTable) 
				do: [:ea | self executeSQLStringNoResult: ea]]
		ifError: aBlock.