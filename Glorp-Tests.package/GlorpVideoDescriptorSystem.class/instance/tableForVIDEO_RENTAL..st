tables
tableForVIDEO_RENTAL: aTable
	| custName custDate storeId customerTable |
	(aTable createFieldNamed: 'ID' type: (platform int4)) bePrimaryKey.
	customerTable := self tableNamed: 'VIDEO_CUSTOMER'.
	custName := aTable createFieldNamed: 'CUSTOMERNAME' type: (platform varchar: 50).
	custDate := aTable createFieldNamed: 'CUSTOMERBIRTHDATE' type: platform date.
	storeId := aTable createFieldNamed: 'STORE_ID' type: (platform int4).
	aTable addForeignKeyFrom: custName
		to: (customerTable fieldNamed: 'CUSTOMERNAME')
		from: custDate
		to: (customerTable fieldNamed: 'BIRTHDATE')
		from: storeId
		to: (customerTable fieldNamed: 'STORE_ID').
	aTable addForeignKeyFrom: storeId to: ((self tableNamed: 'VIDEO_STORE') fieldNamed: 'ID').

	aTable createFieldNamed: 'TITLE' type: (platform varchar: 50).	
	aTable createFieldNamed: 'DUE_DATE' type: platform date.
	aTable createFieldNamed: 'PRICE' type: (platform double).