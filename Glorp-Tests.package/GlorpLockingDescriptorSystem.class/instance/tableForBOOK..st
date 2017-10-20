tables
tableForBOOK: aTable

	(aTable createFieldNamed: 'ID' type: platform serial) bePrimaryKey.
	aTable createFieldNamed: 'TITLE' type: (platform varChar: 100).
	aTable createFieldNamed: 'DESCRIPTION' type: (platform varChar: 255).
	aTable createFieldNamed: 'COPIES_IN_STOCK' type: (platform int4).
	(aTable createFieldNamed: 'VERSION' type: (platform versionFieldFor: platform int4)) beLockKey.