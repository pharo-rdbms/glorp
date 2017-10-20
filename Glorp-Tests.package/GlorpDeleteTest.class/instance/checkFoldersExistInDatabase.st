tests
checkFoldersExistInDatabase
	| result |
	result := session accessor 
				executeSQLString: 'SELECT * FROM GR_FOLDER WHERE USER_ID=1'.
	self assert: result size = 2.