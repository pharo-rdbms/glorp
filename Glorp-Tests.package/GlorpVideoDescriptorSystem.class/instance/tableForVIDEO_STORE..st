tables
tableForVIDEO_STORE: aTable
	(aTable createFieldNamed: 'ID' type: (platform int4)) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varchar: 20).