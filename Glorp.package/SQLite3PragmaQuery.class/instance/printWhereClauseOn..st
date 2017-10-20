sql generation
printWhereClauseOn: aCommand

	self hasEmptyWhereClause
		ifFalse: 
			[whereClause rightChild printSQLOn: aCommand withParameters: aCommand parameters]