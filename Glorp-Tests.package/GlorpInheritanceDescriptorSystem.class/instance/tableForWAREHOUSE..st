tables
tableForWAREHOUSE: aTable

	(aTable createFieldNamed: 'ID' type: platform serial) bePrimaryKey.
	aTable createFieldNamed: 'ADDRESS' type: (platform varChar: 50).
	aTable createFieldNamed: 'CURRENT_ITEM_ID' type: platform int4.