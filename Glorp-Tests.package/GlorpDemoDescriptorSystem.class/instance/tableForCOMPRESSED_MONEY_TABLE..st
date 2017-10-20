tables
tableForCOMPRESSED_MONEY_TABLE: aTable
	(aTable createFieldNamed: 'ID' type: platform int4)
		bePrimaryKey.
	aTable createFieldNamed: 'CURRENCY_NAME' type: (platform varChar: 20).
	aTable createFieldNamed: 'AMOUNT' type: platform int4.