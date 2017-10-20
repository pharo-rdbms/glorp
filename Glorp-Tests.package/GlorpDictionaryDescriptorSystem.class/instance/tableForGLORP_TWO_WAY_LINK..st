tables
tableForGLORP_TWO_WAY_LINK: aTable
	| leftId rightId |
	leftId := aTable createFieldNamed: 'LEFT_ID' type: platform int4.
	leftId bePrimaryKey.
	rightId := aTable createFieldNamed: 'RIGHT_ID' type: platform int4.
	rightId bePrimaryKey.
	aTable addForeignKeyFrom: leftId to: ((self tableNamed: 'GLORP_TASKED_WORKER') fieldNamed: 'ID').
	aTable addForeignKeyFrom: rightId to: ((self tableNamed: 'GLORP_WORKER_TASK') fieldNamed: 'ID').
	aTable createFieldNamed: 'KEY_COLUMN' type: (platform varChar: 10).
	aTable createFieldNamed: 'UNUSED_COLUMN' type: (platform varChar: 10).