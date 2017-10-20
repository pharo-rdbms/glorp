tables
tableForGLORP_WORKER_TASK: aTable
	| id |
	id := aTable createFieldNamed: 'ID' type: platform int4.
	id bePrimaryKey.
	aTable createFieldNamed: 'DESCRIPTION' type: (platform varchar: 30).