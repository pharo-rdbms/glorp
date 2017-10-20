owner
tableForGLORP_SLAVE: aTable
	| field constraint |
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'POSITION_IN_OWNER' type: platform int4.
	field := aTable createFieldNamed: 'OWNER_ID' type: platform int4.
	"Don't actually create this constraint because it causes a cycle that can confuse our sorting mechanism."
	"constraint := aTable
		addForeignKeyFrom: field
		to: ((self tableNamed: 'GLORP_OWNER') fieldNamed: 'ID').
	constraint shouldCreateInDatabase: false."