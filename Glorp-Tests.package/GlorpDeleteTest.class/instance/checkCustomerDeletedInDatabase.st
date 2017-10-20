tests
checkCustomerDeletedInDatabase
	| result |
	result := session accessor 
				executeSQLString: 'SELECT * FROM GR_CUSTOMER WHERE ID=1'.
	self assert: result isEmpty