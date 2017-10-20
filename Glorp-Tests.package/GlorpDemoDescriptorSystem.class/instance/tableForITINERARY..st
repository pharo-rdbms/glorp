tables/airline
tableForITINERARY: aTable 

	| res |
	(aTable createFieldNamed: 'ID' type: platform serial)
		bePrimaryKey.
	res := aTable createFieldNamed: 'RES_ID' type: (platform int4).
	aTable addForeignKeyFrom: res
		to: ((self tableNamed: 'RESERVATION') fieldNamed: 'ID').