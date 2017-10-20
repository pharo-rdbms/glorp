tests
testPrimaryKeyFields2

	| table field |
	table := DatabaseTable new.
	field := (DatabaseField named: 'FRED' type: (dbPlatform varChar: 10))
		bePrimaryKey.
	table addField: field.
	self assert: table primaryKeyFields size = 1.
	self assert: (table primaryKeyFields at: 1) == field.