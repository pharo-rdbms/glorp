tables
tableForBANK_ACCT: aTable

	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'BANK_CODE' type: (platform varChar: 10).
	aTable createFieldNamed: 'BRANCH_NO' type: (platform int4).
	aTable createFieldNamed: 'ACCT_NO' type: (platform varChar: 10).