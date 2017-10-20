tables/airline
tableForAIRLINE: aTable

	(aTable createFieldNamed: 'ID' type: platform inMemorySequence) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20)