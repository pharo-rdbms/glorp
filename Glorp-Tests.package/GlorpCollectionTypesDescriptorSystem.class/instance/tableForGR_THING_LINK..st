tables
tableForGR_THING_LINK: aTable
	| ownerId thingId |
	ownerId := (aTable createFieldNamed: 'OWNER_ID' type: platform int4) bePrimaryKey.
	aTable addForeignKeyFrom: ownerId to: (self ownerTable fieldNamed: 'ID').
	thingId := (aTable createFieldNamed: 'THING_ID' type: platform int4) bePrimaryKey.
	aTable
		addForeignKeyFrom: thingId
		to: (self thingOneTable fieldNamed: 'ID').
	aTable createFieldNamed: 'TYPE' type: (platform char: 1).
	aTable createFieldNamed: 'POSITION' type: platform int4.