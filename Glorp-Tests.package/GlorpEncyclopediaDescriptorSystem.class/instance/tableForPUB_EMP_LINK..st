tables
tableForPUB_EMP_LINK: aTable 

	| pubId titleId |
	pubId := aTable createFieldNamed: 'PUBLISHER_ID' type: platform int4.
	aTable addForeignKeyFrom: pubId  to: ((self tableNamed: 'GR_PUBLISHER') fieldNamed: 'ID').
	titleId := aTable createFieldNamed: 'EMP_ID' type: platform int4.
	aTable addForeignKeyFrom: titleId  to: ((self tableNamed: 'PUBLISHER_EMP') fieldNamed: 'ID').
	aTable createFieldNamed: 'FOO' type: (platform varchar: 5).