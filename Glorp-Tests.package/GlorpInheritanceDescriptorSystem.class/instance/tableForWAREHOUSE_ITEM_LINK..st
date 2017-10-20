tables
tableForWAREHOUSE_ITEM_LINK: aTable

	| warehouseId |
	warehouseId := aTable createFieldNamed: 'WAREHOUSE_ID' type: platform int4.
	aTable addForeignKeyFrom: warehouseId to: ((self tableNamed: 'WAREHOUSE') fieldNamed: 'ID').
	aTable createFieldNamed: 'ITEM_ID' type: platform int4.