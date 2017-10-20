tables
tableForCUSTOMER_ACCT_LINK: aTable

	| customerId accountId |
	customerId := (aTable createFieldNamed: 'CUSTOMER_ID' type: platform int4).
	aTable addForeignKeyFrom: customerId to: ((self tableNamed: 'GR_CUSTOMER') fieldNamed: 'ID').
	accountId := aTable createFieldNamed: 'ACCT_ID' type: platform int4.
	aTable addForeignKeyFrom: accountId to: ((self tableNamed: 'BANK_ACCT') fieldNamed: 'ID').
	aTable addIndexForFields: (Array with: customerId with: accountId).