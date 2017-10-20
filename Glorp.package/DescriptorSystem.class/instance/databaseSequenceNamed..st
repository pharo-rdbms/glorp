api
databaseSequenceNamed: aString

	^sequences at: aString asUppercase ifAbsentPut: [platform newDatabaseSequenceNamed: aString].