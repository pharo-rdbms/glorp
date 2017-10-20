tables/airline
tableForRESERVATION: aTable 

	| pass |
	(aTable createFieldNamed: 'ID' type: platform int4)
		bePrimaryKey.
	pass := aTable createFieldNamed: 'PASS_ID' type: (platform int4).
	aTable addForeignKeyFrom: pass
		to: ((self tableNamed: 'PASSENGER') fieldNamed: 'ID').