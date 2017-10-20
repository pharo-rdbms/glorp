tables
tableForGR_THINGWITHCOLLECTIONS: aTable

	(aTable createFieldNamed: 'ID' type: platform serial) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).