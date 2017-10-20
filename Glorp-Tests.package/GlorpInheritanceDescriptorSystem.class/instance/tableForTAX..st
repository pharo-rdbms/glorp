tables
tableForTAX: aTable
	| superTaxId |
	(aTable createFieldNamed: 'ID' type: platform serial) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: platform text.
	aTable createFieldNamed: 'TYPE' type: (platform varchar: 16).
	superTaxId := aTable createFieldNamed: 'TAX_ID' type: platform int4.
	aTable addForeignKeyFrom: superTaxId to: ((self tableNamed: 'TAX') fieldNamed: 'ID').