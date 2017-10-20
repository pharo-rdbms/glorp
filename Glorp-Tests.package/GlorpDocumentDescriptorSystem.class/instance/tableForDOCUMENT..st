glorp
tableForDOCUMENT: aTable 
	(aTable createFieldNamed: 'id' type: platform sequence) bePrimaryKey.
	aTable createFieldNamed: 'whatever' type: (platform integer).