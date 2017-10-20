tables
tableForENCYC_ENTRY_LINK: aTable 

	| encycId entryId |
	encycId := aTable createFieldNamed: 'ENCYC_ID' type: platform int4.
	encycId bePrimaryKey.
	aTable addForeignKeyFrom: encycId to: ((self tableNamed: 'ENCYC') fieldNamed: 'ID').

	entryId := aTable createFieldNamed: 'ENCYC_ENTRY_ID' type: (platform varChar: 50).
	aTable addForeignKeyFrom: entryId to: ((self tableNamed: 'ENCYC_ENTRY') fieldNamed: 'ID').
	(aTable createFieldNamed: 'REFERENCE_NO' type: (platform varChar: 10)) bePrimaryKey.