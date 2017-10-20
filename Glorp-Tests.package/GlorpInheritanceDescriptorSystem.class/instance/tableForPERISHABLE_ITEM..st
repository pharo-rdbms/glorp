tables
tableForPERISHABLE_ITEM: aTable
	aTable name: 'PERISHABLE_ITEM'.
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
	aTable createFieldNamed: 'AGE' type: platform int4.