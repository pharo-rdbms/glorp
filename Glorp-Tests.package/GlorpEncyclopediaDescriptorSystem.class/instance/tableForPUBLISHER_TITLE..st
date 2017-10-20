tables
tableForPUBLISHER_TITLE: aTable 

	| pubId |
	pubId := aTable createFieldNamed: 'PUBLISHER_ID' type: platform int4.
	aTable addForeignKeyFrom: pubId  to: ((self tableNamed: 'GR_PUBLISHER') fieldNamed: 'ID').
	aTable createFieldNamed: 'POSITION' type: (platform int4).	
	aTable createFieldNamed: 'TITLE' type: (platform varChar: 50).