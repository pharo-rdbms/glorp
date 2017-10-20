tables
tableForEMPLOYEE: aTable
	| officeId |
	aTable name: 'EMPLOYEE'.
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
	officeId := aTable createFieldNamed: 'OFFICE_ID' type: platform int4.
	aTable addForeignKeyFrom: officeId
		to: ((self tableNamed: 'OFFICE') fieldNamed: 'ID').
	aTable createFieldNamed: 'EMPLOYEE_TYPE' type: (platform varChar: 20).
	aTable createFieldNamed: 'BRANCH' type: (platform varChar: 20).
	aTable createFieldNamed: 'REGION' type: (platform varChar: 20).
	aTable createFieldNamed: 'PRODUCTION_LINE' type: (platform varChar: 20).