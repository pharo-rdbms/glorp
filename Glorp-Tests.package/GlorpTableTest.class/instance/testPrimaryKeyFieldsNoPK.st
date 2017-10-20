tests
testPrimaryKeyFieldsNoPK

	| pkFields table |
	table := system tableNamed: 'CUSTOMER_ACCT_LINK'.
	pkFields := table primaryKeyFields.
	self assert: pkFields size = 0.