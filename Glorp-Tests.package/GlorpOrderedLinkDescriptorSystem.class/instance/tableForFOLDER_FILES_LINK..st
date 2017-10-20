tables
tableForFOLDER_FILES_LINK: aTable
	"The chief purpose of this system is to explore what happens when we do not set primary keys, thus causing the cindex order field to pecome one of the 'all fields' primary key that is then computed."

	| folderId fileId |
	folderId := aTable createFieldNamed: 'FOLDER_ID' type: platform int4.
	aTable addForeignKeyFrom: folderId to: ((self tableNamed: 'FOLDERS') fieldNamed: 'ID').
	fileId := aTable createFieldNamed: 'FILE_ID' type: platform int4.
	aTable addForeignKeyFrom: fileId to: ((self tableNamed: 'FILES') fieldNamed: 'ID').
	aTable createFieldNamed: 'cindex' type: platform int.
	folderId bePrimaryKey.
	fileId bePrimaryKey.