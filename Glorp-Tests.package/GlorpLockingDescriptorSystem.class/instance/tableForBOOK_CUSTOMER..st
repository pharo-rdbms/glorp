tables
tableForBOOK_CUSTOMER: aTable

	(aTable createFieldNamed: 'ACCOUNT_NUMBER' type: (platform varChar: 15)) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 100).