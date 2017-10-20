tests
setUpCustomer
	session beginTransaction.
	session accessor 
		executeSQLStringNoResult: 'INSERT INTO GR_CUSTOMER VALUES (1,''Fred Flintstone'')'.
	^session readOneOf: GlorpCustomer where: [:each | each id = 1].