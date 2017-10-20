tests
setUpPersonWithAddress
	session beginTransaction.
	session accessor 
		executeSQLStringNoResult: 'INSERT INTO GR_ADDRESS VALUES (2,''Paseo Montril'', ''999'')'.
	session accessor 
		executeSQLStringNoResult: 'INSERT INTO PERSON VALUES (1,''Fred Flintstone'', 2)'.
	^session readOneOf: GlorpPerson where: [:each | each id = 1].