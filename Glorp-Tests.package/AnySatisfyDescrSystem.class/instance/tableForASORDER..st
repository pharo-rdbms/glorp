accessing
tableForASORDER: aTable

	| field |

	(aTable createFieldNamed: 'ORDERNO' type: platform integer) bePrimaryKey.
	field := aTable createFieldNamed: 'CUSTOMERID' type: platform integer.
	aTable addForeignKeyFrom: field to: ((self tableNamed: 'ASCUSTOMER') fieldNamed: 'ID').