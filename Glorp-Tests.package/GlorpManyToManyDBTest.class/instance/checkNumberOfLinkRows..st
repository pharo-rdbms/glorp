tests-read
checkNumberOfLinkRows: anInteger
	| linkRows |
	linkRows := session accessor
		executeSQLString: 'SELECT * FROM CUSTOMER_ACCT_LINK'.
	self assert: linkRows size = anInteger.