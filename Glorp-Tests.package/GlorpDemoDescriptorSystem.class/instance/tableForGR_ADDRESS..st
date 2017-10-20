tables
tableForGR_ADDRESS: aTable 

	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'STREET' type: (platform varChar: 20).
	aTable createFieldNamed: 'HOUSE_NUM' type: (platform varChar: 20)