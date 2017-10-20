glorp
tableForATTACHMENT: aTable 
	| d |
	d := (aTable createFieldNamed: 'document_id' type: platform int4) 
				bePrimaryKey.
	(aTable createFieldNamed: 'indexInDocument' type: platform int) bePrimaryKey.
	aTable createFieldNamed: 'mimetype' type: (platform varchar: 32).

	"FK Constraints"
	aTable addForeignKeyFrom: d
		to: ((self tableNamed: 'document') fieldNamed: 'id')