printing
printOnlySelfOn: aStream

	table printSQLOn: aStream withParameters: #().
	self printTableAliasesOn: aStream.