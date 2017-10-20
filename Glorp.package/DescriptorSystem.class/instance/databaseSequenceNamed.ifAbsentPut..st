api
databaseSequenceNamed: aString ifAbsentPut: aBlock

	^sequences at: aString asUppercase ifAbsentPut: aBlock