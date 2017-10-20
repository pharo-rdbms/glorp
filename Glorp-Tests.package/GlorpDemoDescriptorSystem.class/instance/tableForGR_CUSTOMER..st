tables
tableForGR_CUSTOMER: aTable 
	(aTable createFieldNamed: 'ID' type: platform int4)
		bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20)