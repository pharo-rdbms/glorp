tests
checkFoldersDeletedInDatabase
	| result generalResult |
	result := session accessor 
				executeSQLString: 'SELECT * FROM GR_FOLDER WHERE USER_ID=1'.
	self assert: result isEmpty.

	generalResult := session accessor 
				executeSQLString: 'SELECT * FROM GR_FOLDER'.
	self assert: generalResult size = 1.