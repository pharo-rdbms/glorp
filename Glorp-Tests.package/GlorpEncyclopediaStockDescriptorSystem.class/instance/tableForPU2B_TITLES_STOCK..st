tables
tableForPU2B_TITLES_STOCK: aTable 
	"Use a different table name to avoid conflicts with GlorpEncyclopediaDescriptorSystem."

	| pubId |
	pubId := (aTable createFieldNamed: 'TINY_PUBLISHER_ID' type: platform int4) bePrimaryKey; yourself.
	aTable addForeignKeyFrom: pubId  to: ((self tableNamed: 'GR_TINY_PUBLISHER') fieldNamed: 'ID').
	(aTable createFieldNamed: 'TITLE' type: (platform varChar: 50)) bePrimaryKey.
	aTable createFieldNamed: 'STOCK' type: platform int4.
	aTable createFieldNamed: 'UNUSED' type: (platform varchar: 10).