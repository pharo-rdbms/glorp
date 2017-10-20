accessing
tableForASORDERLINEITEM: aTable

	| field |

	(aTable createFieldNamed: 'POSNO' type: platform integer) bePrimaryKey.
	aTable createFieldNamed: 'QUANTITY' type: (platform number precision: 9; scale: 4; yourself).
	aTable createFieldNamed: 'PRICE' type: (platform number precision: 9; scale: 4; yourself).

	field := aTable createFieldNamed: 'ORDERORDERNO' type: platform integer.
	aTable addForeignKeyFrom: field to: ((self tableNamed: 'ASORDER') fieldNamed: 'ORDERNO').
	field bePrimaryKey.

	field := aTable createFieldNamed: 'ITEMID' type: platform integer.
	aTable addForeignKeyFrom: field to: ((self tableNamed: 'ASITEM') fieldNamed: 'ID').