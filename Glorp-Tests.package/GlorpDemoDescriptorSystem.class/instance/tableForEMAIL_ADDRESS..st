tables
tableForEMAIL_ADDRESS: aTable

	| personId |
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	(aTable createFieldNamed: 'USER_NAME' type: (platform varChar: 20)) beIndexed.
	aTable createFieldNamed: 'HOST_NAME' type: (platform varChar: 20).
	personId := aTable createFieldNamed: 'PERSON_ID' type: platform int4.
	personId beIndexed.
	(aTable addForeignKeyFrom: personId to: ((self tableNamed: 'PERSON') fieldNamed: 'ID')).