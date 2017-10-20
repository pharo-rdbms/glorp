descriptors/other
tableForRECORD_WITH_UPDATE: aTable 
	| |
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	(aTable createFieldNamed: 'NAME' type: (platform varchar: 20)).
	aTable createFieldNamed: 'UPDATE_TIME' type: (platform versionFieldFor: platform timestamp) generateOverExistingValues.
	"OK, it's not much of a comment, we just print the current time. Note that this field is completely unmapped"
	aTable createFieldNamed: 'UPDATE_COMMENT' type: (platform generatorFor: (platform varchar: 20) withBlock: [Time now printString]) generateOverExistingValues.
	"But this one *is* mapped"
	aTable createFieldNamed: 'UPDATE_OTHER_THING' type: (platform generatorFor: (platform varchar: 20) withBlock: [Time now printString]) generateOverExistingValues.