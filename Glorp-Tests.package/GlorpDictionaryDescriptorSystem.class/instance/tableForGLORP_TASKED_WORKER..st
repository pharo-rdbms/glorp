tables
tableForGLORP_TASKED_WORKER: aTable
	| id |
	id := aTable createFieldNamed: 'ID' type: platform int4.
	id bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varchar: 30).