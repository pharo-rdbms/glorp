tables/airline
tableForFLIGHT: aTable

	aTable name: 'FLIGHT'.
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'FLIGHT_NUM' type: platform int4