accessing
attributeNamed: aSymbol
	^attributes detect: [:each | each name = aSymbol] ifNone: [self newAttributeNamed: aSymbol]