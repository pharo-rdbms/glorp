tables
tableForGR_MESSAGE: aTable 
	| userId folderName |
	userId := aTable createFieldNamed: 'USER_ID' type: platform integer.
	userId bePrimaryKey.
	folderName := aTable createFieldNamed: 'FOLDER_NAME' type: (platform varChar: 50).
	folderName bePrimaryKey.
	aTable addForeignKeyFrom: userId
		to: ((self tableNamed: 'GR_USER') fieldNamed: 'ID').

	aTable addForeignKeyFrom: userId
		to: ((self tableNamed: 'GR_FOLDER') fieldNamed: 'USER_ID')
		from: folderName
		to: ((self tableNamed: 'GR_FOLDER') fieldNamed: 'NAME').


	(aTable createFieldNamed: 'SUBJECT' type: (platform varChar: 50)) bePrimaryKey.
	aTable createFieldNamed: 'CONTENTS' type: (platform varChar: 100).