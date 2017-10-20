tables
tableForVIDEO_CREDIT_STATUS: aTable
	| customerTable custName custDate storeId |
	customerTable := self tableNamed: 'VIDEO_CUSTOMER'.
	custName := (aTable createFieldNamed: 'CUSTOMERNAME' type: (platform varchar: 50))
		bePrimaryKey.
	custDate := (aTable createFieldNamed: 'CUSTOMERBIRTHDATE' type: platform date) bePrimaryKey.
	storeId := (aTable createFieldNamed: 'STORE_ID' type: platform int4) bePrimaryKey.
	aTable addForeignKeyFrom: custName
		to: (customerTable fieldNamed: 'CUSTOMERNAME')
		from: custDate
		to: (customerTable fieldNamed: 'BIRTHDATE')
		from: storeId
		to: (customerTable fieldNamed: 'STORE_ID') .
	aTable addForeignKeyFrom: storeId to: ((self tableNamed: 'VIDEO_STORE') fieldNamed: 'ID').

	aTable createFieldNamed: 'BALANCE' type: (platform double).
	aTable createFieldNamed: 'DATE_OWING' type: platform date.
	aTable createFieldNamed: 'COMMENTS' type: (platform varchar: 50).