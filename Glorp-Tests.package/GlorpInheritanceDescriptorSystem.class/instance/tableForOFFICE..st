tables
tableForOFFICE: aTable
	| empOfMonth |
	aTable name: 'OFFICE'.
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	empOfMonth := aTable createFieldNamed: 'EMPLOYEE_OF_MONTH' type: platform int4.
	"Cheat by removing this, because it makes a cycle that we can't really handle yet"
	"aTable addForeignKeyFrom: empOfMonth
		to: ((self tableNamed: 'EMPLOYEE') fieldNamed: 'ID')."