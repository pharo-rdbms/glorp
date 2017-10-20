initialize-release
setAttribute: aSymbol fromDb: fromBlock toDb: toBlock mappingFields: aFieldCollection
 
	self attributeName: aSymbol.
	fromDbMappingBlock := fromBlock.
	toDbMappingBlock := toBlock.
	mappedFields := aFieldCollection