tables
tableForVIDEO_PURCHASE: aTable
	| custName custDate customerTable |
	(aTable createFieldNamed: 'ID' type: (platform int4)) bePrimaryKey.
	customerTable := self tableNamed: 'VIDEO_CUSTOMER'.
	custName := aTable createFieldNamed: 'CUSTOMERNAME' type: (platform varchar: 50).
	custDate := aTable createFieldNamed: 'CUSTOMERBIRTHDATE' type: platform date.
	aTable addForeignKeyFrom: custName
		to: (customerTable fieldNamed: 'CUSTOMERNAME')
		from: custDate
		to: (customerTable fieldNamed: 'BIRTHDATE').

	aTable createFieldNamed: 'TITLE' type: (platform varchar: 50).	
	aTable createFieldNamed: 'PRICE' type: (platform double).
	aTable createFieldNamed: 'IN_STORE' type: (platform char: 1).