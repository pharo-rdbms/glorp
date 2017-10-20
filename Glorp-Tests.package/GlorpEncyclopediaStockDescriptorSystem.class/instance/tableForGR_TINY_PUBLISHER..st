tables
tableForGR_TINY_PUBLISHER: aTable 

	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 50).