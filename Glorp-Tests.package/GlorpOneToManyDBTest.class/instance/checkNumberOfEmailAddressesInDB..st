support
checkNumberOfEmailAddressesInDB: numberOfAddresses
	| databaseAddresses |
	databaseAddresses := session accessor executeSQLString: 'SELECT * FROM EMAIL_ADDRESS'.
	self assert: databaseAddresses size = numberOfAddresses.