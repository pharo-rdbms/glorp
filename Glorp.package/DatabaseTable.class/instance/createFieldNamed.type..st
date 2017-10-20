fields
createFieldNamed: aString type: dbType

	| existingField |
	existingField := fields detect: [:each | each name = aString] ifNone: [nil].
	(existingField notNil)
	ifTrue: [self error: 'field ', aString, ' already exists'].
	^self addField: (DatabaseField named: aString type: dbType)