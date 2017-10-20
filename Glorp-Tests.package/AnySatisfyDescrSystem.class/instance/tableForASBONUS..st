accessing
tableForASBONUS: aTable

	(aTable createFieldNamed: 'ID' type: platform integer) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
	aTable createFieldNamed: 'CREDITS' type: (platform integer).