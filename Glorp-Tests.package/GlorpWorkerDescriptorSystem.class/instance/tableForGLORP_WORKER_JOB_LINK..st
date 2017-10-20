tables
tableForGLORP_WORKER_JOB_LINK: aTable

	| workerId jobId |
	workerId := aTable createFieldNamed: 'WORKER_ID' type: platform int4.
	aTable addForeignKeyFrom: workerId
		to: ((self tableNamed: 'GLORP_WORKER') fieldNamed: 'ID').
	jobId := aTable createFieldNamed: 'JOB_ID' type: platform int4.
	aTable addForeignKeyFrom: jobId
		to: ((self tableNamed: 'GLORP_JOB') fieldNamed: 'ID').
	aTable createFieldNamed: 'PRIORITY' type: (platform varChar: 1).