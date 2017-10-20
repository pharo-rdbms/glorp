tests
testCircularFieldRefs

	| field table1 table2 |
	table1 := DatabaseTable named: 'BAR'.
	field := table1 createFieldNamed: 'FOO' type: dbPlatform int4.
	table2 := DatabaseTable named: 'BLETCH'.
	table1 addForeignKeyFrom: field to: (table2 createFieldNamed: 'FLIRP' type: dbPlatform int4).
	self assert: (table2 fieldNamed: 'FLIRP') = table1 foreignKeyConstraints first targetFields first.