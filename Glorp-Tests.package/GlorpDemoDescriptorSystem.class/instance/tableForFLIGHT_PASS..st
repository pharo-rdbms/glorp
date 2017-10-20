tables/airline
tableForFLIGHT_PASS: aTable

	| flight pass airline |
	aTable name: 'FLIGHT_PASS'.
	flight := aTable createFieldNamed: 'FLIGHT_ID' type: platform int4.
	aTable addForeignKeyFrom: flight
		to: ((self tableNamed: 'FLIGHT') fieldNamed: 'ID').
	pass := aTable createFieldNamed: 'PASS_ID' type: platform int4.
	aTable addForeignKeyFrom: pass
		to: ((self tableNamed: 'PASSENGER') fieldNamed: 'ID').
	airline := aTable createFieldNamed: 'AIRLINE_ID' type: platform int4.
	aTable addForeignKeyFrom: airline
		to: ((self tableNamed: 'AIRLINE') fieldNamed: 'ID').