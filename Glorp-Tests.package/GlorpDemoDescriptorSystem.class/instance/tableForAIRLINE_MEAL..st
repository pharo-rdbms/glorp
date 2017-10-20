tables/airline
tableForAIRLINE_MEAL: aTable

	aTable createFieldNamed: 'ID' type: platform int4.
	aTable createFieldNamed: 'DESCR' type: (platform varChar: 20).
	aTable createFieldNamed: 'FLIGHT_ID' type: platform int4