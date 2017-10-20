tables
tableForFILES: aTable
	(aTable createFieldNamed: 'ID' type: platform sequence) bePrimaryKey.
	aTable createFieldNamed: 'name' type: (platform varChar: 50)