descriptors
workerCriteriaWithConstant: aString in: table 
	^Join 
		from: (table fieldNamed: 'ID')
		to: ((self tableNamed: 'GLORP_JOB') fieldNamed: 'OWNER_ID')
		from: aString
		to: ((self tableNamed: 'GLORP_JOB') fieldNamed: 'FINISHED').