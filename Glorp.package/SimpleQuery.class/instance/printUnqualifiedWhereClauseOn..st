sql generation
printUnqualifiedWhereClauseOn: aCommand
	self hasEmptyWhereClause
		ifFalse:
			[aCommand
				cr;
				nextPutAll: ' WHERE '.
			whereClause printUnqualifiedSQLOn: aCommand withParameters: aCommand parameters].