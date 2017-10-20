tables
tableForPUBLISHER_EMP: aTable 

	| |
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 50).	
	aTable createFieldNamed: 'JOBTITLE' type: (platform varChar: 50).