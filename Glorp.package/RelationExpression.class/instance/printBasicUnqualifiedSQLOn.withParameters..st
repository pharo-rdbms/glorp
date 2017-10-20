printing SQL
printBasicUnqualifiedSQLOn: aCommand withParameters: aDictionary
	aCommand nextPut: $(.
	leftChild printUnqualifiedSQLOn: aCommand withParameters: aDictionary.
	self printUnqualifiedComparisonTo: rightChild withParameters: aDictionary on: aCommand.
	self printOracleOuterJoinOn: aCommand.
	aCommand nextPut: $)