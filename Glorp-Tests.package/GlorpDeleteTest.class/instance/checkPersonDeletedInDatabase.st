tests
checkPersonDeletedInDatabase
	| result |
	result := session accessor 
				executeSQLString: 'SELECT * FROM PERSON WHERE ID=1'.
	self assert: result isEmpty