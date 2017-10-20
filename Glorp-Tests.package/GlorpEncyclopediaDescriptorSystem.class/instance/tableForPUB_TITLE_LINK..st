tables
tableForPUB_TITLE_LINK: aTable 

	| pubId titleId |
	pubId := aTable createFieldNamed: 'PUBLISHER_ID' type: platform int4.
	aTable addForeignKeyFrom: pubId  to: ((self tableNamed: 'GR_PUBLISHER') fieldNamed: 'ID').
	titleId := aTable createFieldNamed: 'TITLE_ID' type: platform int4.
	aTable addForeignKeyFrom: titleId  to: ((self tableNamed: 'PUBLISHER_TITLE2') fieldNamed: 'ID').
	aTable createFieldNamed: 'STOCK' type: platform int4.