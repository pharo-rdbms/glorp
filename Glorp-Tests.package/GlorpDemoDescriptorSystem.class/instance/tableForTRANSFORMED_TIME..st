tables
tableForTRANSFORMED_TIME: aTable
	(aTable createFieldNamed: 'ID' type: platform int4)
		bePrimaryKey.
	aTable createFieldNamed: 'TIMEFIELD' type: platform int4.