tables/airline
tableForGR_TRAVEL_AGENT: aTable 

	(aTable createFieldNamed: 'ID' type: platform int4)
		bePrimaryKey.
	aTable createFieldNamed: 'AGENT_NAME' type: (platform varchar: 50).
	aTable createFieldNamed: 'AGENCY_NAME' type: (platform varchar: 50).