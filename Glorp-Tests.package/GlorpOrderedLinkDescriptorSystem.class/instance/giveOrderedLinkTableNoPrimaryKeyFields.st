initialize-release
giveOrderedLinkTableNoPrimaryKeyFields
	"The chief purpose of this system is to explore what happens when we do not set primary keys, thus causing the cindex order field to pecome one of the 'all fields' primary key that is then computed."

	| table |
	table := self tableNamed: 'FOLDER_FILES_LINK'.
	(table fieldNamed: 'FOLDER_ID')
		instVarNamed: 'isPrimaryKey' put: false.
	(table fieldNamed: 'FILE_ID')
		instVarNamed: 'isPrimaryKey' put: false.
	table instVarNamed: 'primaryKeyFields' put: nil.