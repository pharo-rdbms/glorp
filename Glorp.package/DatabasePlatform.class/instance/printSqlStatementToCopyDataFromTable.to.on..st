services columns
printSqlStatementToCopyDataFromTable: fromTable to: toTable on: aStream

	aStream
		nextPutAll: 'INSERT INTO ';
		nextPutAll: (self ddlTableNameFor: toTable);
		nextPutAll: ' ( '.

	GlorpHelper 
		print: [:each | self nameForColumn: each name]
		on: aStream
		for: fromTable fields
		separatedBy: ','.


	aStream
		nextPutAll: ' ) ';
		nextPutAll: ' SELECT '.

	GlorpHelper 
		print: [:each | self nameForColumn: each name]
		on: aStream
		for: fromTable fields
		separatedBy: ','.

	aStream
		nextPutAll: ' FROM ';
		nextPutAll: (self ddlTableNameFor: fromTable)