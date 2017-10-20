printing SQL
printBasicSQLOn: aCommand withParameters: aDictionary
	aCommand nextPut: $(.
	leftChild printSQLOn: aCommand withParameters: aDictionary.
	self printComparisonTo: rightChild withParameters: aDictionary on: aCommand.
	self printOracleOuterJoinOn: aCommand.
	aCommand nextPut: $)