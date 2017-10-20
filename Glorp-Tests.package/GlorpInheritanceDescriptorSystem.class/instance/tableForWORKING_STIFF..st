tables
tableForWORKING_STIFF: aTable
	aTable name: 'WORKING_STIFF'.
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).