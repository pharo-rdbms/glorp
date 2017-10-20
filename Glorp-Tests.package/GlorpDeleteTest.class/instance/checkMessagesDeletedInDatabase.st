tests
checkMessagesDeletedInDatabase
	| result generalResult |
	result := session accessor 
				executeSQLString: 'SELECT * FROM GR_MESSAGE WHERE USER_ID = 1'.
	self assert: result isEmpty.

	generalResult := session accessor 
				executeSQLString: 'SELECT * FROM GR_MESSAGE'.
	self assert: generalResult size = 1.