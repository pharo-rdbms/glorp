tests
testPrimaryKeyFields

	| pkFields table |
	table := system tableNamed: 'BANK_TRANS'.
	pkFields := table primaryKeyFields.
	self assert: pkFields size = 1.
	self assert: (pkFields at: 1) == (table fieldNamed: 'ID').