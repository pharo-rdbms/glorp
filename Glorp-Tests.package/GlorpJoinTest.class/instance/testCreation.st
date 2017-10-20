tests
testCreation

	self assert: expression allSourceFields size = 1.
	self assert: expression allSourceFields first == ((system tableNamed: 'BANK_ACCT') fieldNamed: 'ID').