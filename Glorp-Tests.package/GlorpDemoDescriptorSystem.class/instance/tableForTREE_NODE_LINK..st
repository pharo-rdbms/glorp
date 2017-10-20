descriptors/tree nodes
tableForTREE_NODE_LINK: aTable

	| parent child |
	parent := (aTable createFieldNamed: 'PARENT' type: platform int4) bePrimaryKey.
	(aTable addForeignKeyFrom: parent
		to: ((self tableNamed: 'TREE_NODE') fieldNamed: 'ID')) "shouldCreateInDatabase: false"  .
	child := (aTable createFieldNamed: 'CHILD' type: platform int4) bePrimaryKey.
	(aTable addForeignKeyFrom: child
		to: ((self tableNamed: 'TREE_NODE') fieldNamed: 'ID')) "shouldCreateInDatabase: false".