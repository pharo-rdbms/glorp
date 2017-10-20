owner
tableForGLORP_OWNER: aTable
	| field |
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	field := aTable createFieldNamed: 'SLAVE_ID' type: platform int4.
	aTable
		addForeignKeyFrom: field
		to: ((self tableNamed: 'GLORP_SLAVE') fieldNamed: 'ID').