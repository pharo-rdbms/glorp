accessing
tableForASITEMBONUS: aTable

	| field |

	field := aTable createFieldNamed: 'ITEMID' type: platform integer.
	aTable addForeignKeyFrom: field to: ((self tableNamed: 'ASITEM') fieldNamed: 'ID').
	field bePrimaryKey.

	field := aTable createFieldNamed: 'BONUSID' type: platform integer.
	aTable addForeignKeyFrom: field to: ((self tableNamed: 'ASBONUS') fieldNamed: 'ID').