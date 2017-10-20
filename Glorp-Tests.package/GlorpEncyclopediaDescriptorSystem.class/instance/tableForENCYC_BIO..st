tables
tableForENCYC_BIO: aTable 

	| encycId |
	(aTable createFieldNamed: 'TITLE' type: (platform varChar: 50)) bePrimaryKey.
	encycId := aTable createFieldNamed: 'ENCYC_ID' type: platform integer.
	encycId bePrimaryKey.
	aTable addForeignKeyFrom: encycId to: ((self tableNamed: 'ENCYC') fieldNamed: 'ID').
	aTable createFieldNamed: 'ENTRY_TEXT' type: (platform varChar: 50).