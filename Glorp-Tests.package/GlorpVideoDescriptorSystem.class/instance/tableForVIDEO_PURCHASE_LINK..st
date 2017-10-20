tables
tableForVIDEO_PURCHASE_LINK: aTable
	| storeId purchaseId |
	purchaseId := aTable createFieldNamed: 'PURCHASE_ID' type: platform int4.
	storeId := aTable createFieldNamed: 'STORE_ID' type: (platform int4).
	aTable addForeignKeyFrom: storeId
		to: ((self tableNamed: 'VIDEO_STORE') fieldNamed: 'ID').
	aTable addForeignKeyFrom: purchaseId
		to: ((self tableNamed: 'VIDEO_PURCHASE') fieldNamed: 'ID').