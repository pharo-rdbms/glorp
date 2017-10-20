glorp
tableForATTACHMENTBYTES: aTable 
	| d i |
	d := (aTable createFieldNamed: 'attachment_document_id'
				type: platform int4) bePrimaryKey.
	i := (aTable createFieldNamed: 'attachment_index' type: platform int) 
				bePrimaryKey.
	aTable createFieldNamed: 'content' type: platform text.

	"FK"
	aTable 
		addForeignKeyFrom: d
		to: ((self tableNamed: 'attachment') fieldNamed: 'document_id')
		from: i
		to: ((self tableNamed: 'attachment') fieldNamed: 'indexInDocument')