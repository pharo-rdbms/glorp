tests
testFieldTable

	| field table |
	field := DatabaseField named: 'FOO' type: dbPlatform int4.
	table := DatabaseTable named: 'BAR'.
	table addField: field.
	self assert: (table fieldNamed: 'FOO') = field.