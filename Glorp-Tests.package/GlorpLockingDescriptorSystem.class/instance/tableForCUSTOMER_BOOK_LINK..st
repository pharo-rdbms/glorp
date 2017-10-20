tables
tableForCUSTOMER_BOOK_LINK: aTable

	| custKey bookKey |
	custKey := aTable createFieldNamed: 'CUSTOMER_ACCT_NUM' type: (platform varChar: 15).
	aTable addForeignKeyFrom: custKey
		to: ((self tableNamed: 'BOOK_CUSTOMER') fieldNamed: 'ACCOUNT_NUMBER').
	bookKey := aTable createFieldNamed: 'BOOK_ID' type: (platform int4).
		aTable addForeignKeyFrom: bookKey
		to: ((self tableNamed: 'BOOK') fieldNamed: 'ID').