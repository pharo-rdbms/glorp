tables
tableForENCYC_ENTRY: aTable 

	(aTable createFieldNamed: 'ID' type: (platform varChar: 50)) bePrimaryKey.
	aTable createFieldNamed: 'TITLE' type: (platform varChar: 50).
	aTable createFieldNamed: 'ENTRY_TEXT' type: (platform varChar: 200).
	aTable createFieldNamed: 'MEDIA_TYPE_NAME' type: (platform varChar: 100).
	aTable createFieldNamed: 'MEDIA_TYPE_MIME' type: (platform varChar: 100).