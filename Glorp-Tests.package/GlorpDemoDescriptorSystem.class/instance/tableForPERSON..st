tables
tableForPERSON: aTable
	| addrId|
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
	addrId := aTable createFieldNamed: 'ADDRESS_ID' type: platform int4.
	aTable addForeignKeyFrom: addrId to: ((self tableNamed: 'GR_ADDRESS') fieldNamed: 'ID').