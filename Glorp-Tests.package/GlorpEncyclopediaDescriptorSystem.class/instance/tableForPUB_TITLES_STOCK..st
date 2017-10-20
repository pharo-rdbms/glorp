tables
tableForPUB_TITLES_STOCK: aTable 

	| pubId |
	pubId := aTable createFieldNamed: 'PUBLISHER_ID' type: platform int4.
	aTable addForeignKeyFrom: pubId  to: ((self tableNamed: 'GR_PUBLISHER') fieldNamed: 'ID').
	aTable createFieldNamed: 'TITLE' type: (platform varChar: 50).
	aTable createFieldNamed: 'STOCK' type: platform int4.