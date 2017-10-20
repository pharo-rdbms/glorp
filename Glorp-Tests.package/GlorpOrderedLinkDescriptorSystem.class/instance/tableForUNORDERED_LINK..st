tables
tableForUNORDERED_LINK: aTable
	| folderId fileId |
	folderId := aTable createFieldNamed: 'FOLDER_ID' type: platform int4.
	aTable addForeignKeyFrom: folderId
		to: ((self tableNamed: 'FOLDERS') fieldNamed: 'ID').
	fileId := aTable createFieldNamed: 'FILE_ID' type: platform int4.
	aTable addForeignKeyFrom: fileId
		to: ((self tableNamed: 'FILES') fieldNamed: 'ID')