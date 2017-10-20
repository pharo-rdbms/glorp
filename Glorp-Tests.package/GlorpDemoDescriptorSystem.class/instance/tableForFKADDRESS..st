tables
tableForFKADDRESS: aTable 
	| contact |
	(aTable createFieldNamed: 'ID' type: platform serial) bePrimaryKey.
	contact := aTable createFieldNamed: 'CONTACT_ID' type: platform int4.
	aTable addForeignKeyFrom: contact
		to: ((self tableNamed: 'FKCONTACT') fieldNamed: 'ID')