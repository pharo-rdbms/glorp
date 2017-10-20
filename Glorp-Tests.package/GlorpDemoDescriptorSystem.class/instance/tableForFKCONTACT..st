tables
tableForFKCONTACT: aTable 
	| address |
	(aTable createFieldNamed: 'ID' type: platform serial) bePrimaryKey.
	address := aTable createFieldNamed: 'ADDRESS_ID' type: platform int4.
	aTable addForeignKeyFrom: address
		to: ((self tableNamed: 'FKADDRESS') fieldNamed: 'ID')