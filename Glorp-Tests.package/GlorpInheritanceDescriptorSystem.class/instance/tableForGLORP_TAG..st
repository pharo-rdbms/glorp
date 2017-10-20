as yet unclassified
tableForGLORP_TAG: aTable 
	(aTable createFieldNamed: 'id' type: platform sequence) bePrimaryKey.
	aTable
		createFieldNamed: 'key'
		type: (platform varChar: 200).
	aTable
		createFieldNamed: 'label'
		type: (platform varChar: 200).