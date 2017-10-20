as yet unclassified
tableForIMAGETAGS: aTable 
	| tagKey tagObjKey |
	tagKey := aTable createFieldNamed: 'tag_id' type: platform int4.
	aTable
		addForeignKeyFrom: tagKey
		to: ((self tableNamed: 'GLORP_TAG')
				fieldNamed: 'id').
	tagObjKey := aTable createFieldNamed: 'obj_id' type: platform int4.
	aTable
		addForeignKeyFrom: tagObjKey
		to: ((self tableNamed: 'GLORP_IMAGE')
				fieldNamed: 'id')