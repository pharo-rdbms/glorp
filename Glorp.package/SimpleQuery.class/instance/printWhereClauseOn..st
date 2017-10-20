sql generation
printWhereClauseOn: aCommand
	self hasEmptyWhereClause
		ifFalse:
			[aCommand
				cr;
				nextPutAll: ' WHERE '.
			whereClause printSQLOn: aCommand withParameters: aCommand parameters]