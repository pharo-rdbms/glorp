tests-read
checkNumberOfAccounts: anInteger
	| accountRows |
	accountRows := session accessor
		executeSQLString: 'SELECT * FROM BANK_ACCT'.
	self assert: accountRows size = anInteger.