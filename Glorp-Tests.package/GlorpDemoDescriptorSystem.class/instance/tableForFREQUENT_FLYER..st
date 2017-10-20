tables/airline
tableForFREQUENT_FLYER: aTable 
	| airlineId |
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'POINTS' type: platform int4.
	airlineId := aTable createFieldNamed: 'AIRLINE_ID' type: platform int4.
	aTable addForeignKeyFrom: airlineId to: ((self tableNamed: 'AIRLINE') fieldNamed: 'ID').