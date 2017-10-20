support
checkNoAddressesInDB
	| addresses addressKeys |
	addresses := session accessor executeSQLString: 'SELECT * FROM GR_ADDRESS'.
	self assert: addresses isEmpty.
	addressKeys := session accessor executeSQLString: 'SELECT ADDRESS_ID FROM PERSON'.
	self assert: (addressKeys size = 1).
	self assert: (addressKeys first atIndex: 1) = nil.