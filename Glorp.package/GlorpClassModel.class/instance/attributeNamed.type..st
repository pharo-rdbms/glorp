accessing
attributeNamed: aSymbol type: aClass
	^attributes
		detect:
			[:each | each name = aSymbol and: [each type isNil or: [each type = aClass]]]
		ifNone: [self newAttributeNamed: aSymbol type: aClass]