tables
tableForPOULTRY: aTable
	aTable name: 'POULTRY'.
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
	aTable createFieldNamed: 'AGE' type: platform int4.
	aTable createFieldNamed: 'FEATHER_COLOR' type: (platform varChar: 20).