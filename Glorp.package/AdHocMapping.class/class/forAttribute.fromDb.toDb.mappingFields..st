instance creation
forAttribute: aSymbol fromDb: fromBlock toDb: toBlock mappingFields: aFieldCollection 
	^super new 
		setAttribute: aSymbol
		fromDb: fromBlock
		toDb: toBlock
		mappingFields: aFieldCollection