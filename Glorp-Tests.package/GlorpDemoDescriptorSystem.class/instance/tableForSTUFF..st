tables
tableForSTUFF: aTable 

	(aTable createFieldNamed: 'ID' type: platform inMemorySequence)
		bePrimaryKey.
	aTable createFieldNamed: 'THING' type: (platform varChar: 20)