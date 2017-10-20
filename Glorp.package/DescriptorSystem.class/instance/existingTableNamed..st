api
existingTableNamed: aString

	^tables at: aString asUppercase ifAbsent: [self error: 'missing table']