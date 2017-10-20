descriptors/other
tableForDEFAULTABLE_THING: aTable 
	| boolean converter |
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	boolean := aTable createFieldNamed: 'MY_BOOL' type: (platform boolean).
	"We want a default value for this field, but we can't just use a boolean, because in some database we can represent that directly, but in others it will need to be converted to an integer. And likewise we can't just use an integer, so we need to do an explicit conversion."
	converter := boolean converterForStType: Boolean.
	boolean defaultValue: (converter convert: false toDatabaseRepresentationAs: boolean type).
	(aTable createFieldNamed: 'MY_INT' type: (platform int4)) defaultValue: 4.