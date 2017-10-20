tables
tableForVIDEO_CUSTOMER: aTable
	"Note: This table is imaginary"
	| storeId |
	aTable isImaginary: true.
	(aTable createFieldNamed: 'CUSTOMERNAME' type: (platform varchar: 50))
		bePrimaryKey.
	(aTable createFieldNamed: 'BIRTHDATE' type: platform date) bePrimaryKey.
	storeId := (aTable createFieldNamed: 'STORE_ID' type: (platform int4)) bePrimaryKey.
	aTable addForeignKeyFrom: storeId
		to: ((self tableNamed: 'VIDEO_STORE') fieldNamed: 'ID')