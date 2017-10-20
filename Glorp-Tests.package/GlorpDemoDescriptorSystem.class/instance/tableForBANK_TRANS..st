tables
tableForBANK_TRANS: aTable 
	| ownerId |
	(aTable createFieldNamed: 'ID' type: (platform serial: 3))
		bePrimaryKey.
	ownerId := aTable createFieldNamed: 'OWNER_ID' type: platform int4.
	aTable addForeignKeyFrom: ownerId
		to: ((self tableNamed: 'GR_CUSTOMER') fieldNamed: 'ID').
	aTable createFieldNamed: 'AMT_CURR' type: (platform varChar: 5).
	aTable createFieldNamed: 'AMT_AMT' type: platform int4.
	aTable createFieldNamed: 'SRVC_DESC' type: (platform varChar: 30).
	aTable createFieldNamed: 'SRVC_AMT_CURR' type: (platform varChar: 5).
	aTable createFieldNamed: 'SRVC_AMT_AMT' type: platform int4.