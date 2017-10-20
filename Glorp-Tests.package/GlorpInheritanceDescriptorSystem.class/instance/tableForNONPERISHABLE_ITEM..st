tables
tableForNONPERISHABLE_ITEM: aTable
	aTable name: 'NONPERISHABLE_ITEM'.
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
	aTable createFieldNamed: 'SERIAL_NUMBER' type: platform int4.