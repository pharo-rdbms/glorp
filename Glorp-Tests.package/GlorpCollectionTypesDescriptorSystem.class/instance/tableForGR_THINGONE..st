tables
tableForGR_THINGONE: aTable
	| setOwnerId arrayOwnerId |
	(aTable createFieldNamed: 'ID' type: platform serial) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
	setOwnerId := aTable createFieldNamed: 'SET_OWNER' type: platform int4.
	aTable addForeignKeyFrom: setOwnerId
		to: (self ownerTable fieldNamed: 'ID').

	arrayOwnerId := aTable createFieldNamed: 'ARRAY_OWNER' type: platform int4.
	aTable addForeignKeyFrom: arrayOwnerId
		to: (self ownerTable fieldNamed: 'ID').
	aTable createFieldNamed: 'ARRAY_POSITION' type: platform int4.