as yet unclassified
tableForGLORP_IMAGE: aTable 
	(aTable createFieldNamed: 'id' type: platform sequence) bePrimaryKey.
	aTable
		createFieldNamed: 'location'
		type: (platform varChar: 250).