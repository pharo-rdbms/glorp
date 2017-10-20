tables
tableForPUBLISHER_TITLE2: aTable 

	| |
	(aTable createFieldNamed: 'ID' type: platform serial) bePrimaryKey.
	aTable createFieldNamed: 'TITLE' type: (platform varChar: 50).