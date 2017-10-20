tables
tableForGR_FOLDER: aTable 
	| userId |
	userId := aTable createFieldNamed: 'USER_ID' type: platform integer.
	userId bePrimaryKey.
	aTable addForeignKeyFrom: userId
		to: ((self tableNamed: 'GR_USER') fieldNamed: 'ID').
	(aTable createFieldNamed: 'NAME' type: (platform varChar: 50)) bePrimaryKey.