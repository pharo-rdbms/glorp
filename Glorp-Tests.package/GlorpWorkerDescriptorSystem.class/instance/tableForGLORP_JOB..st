tables
tableForGLORP_JOB: aTable

	| ownerId |
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'DESCRIPTION' type: (platform varChar: 40).
	aTable createFieldNamed: 'FINISHED' type: (platform varChar: 1).
	ownerId := aTable createFieldNamed: 'OWNER_ID' type: platform int4.
	aTable addForeignKeyFrom: ownerId
		to: ((self tableNamed: 'GLORP_WORKER') fieldNamed: 'ID').