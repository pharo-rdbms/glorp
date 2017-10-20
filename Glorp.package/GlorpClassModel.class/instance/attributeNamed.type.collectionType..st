accessing
attributeNamed: aSymbol type: aClass collectionType: collectionClass
	^attributes
		detect:
			[:each | 
			| collectionTypeMatches typeMatches nameMatches |
			nameMatches := each name = aSymbol.
			typeMatches := each type isNil or: [each type = aClass].
			collectionTypeMatches := each collectionType isNil
				or: [each collectionType = collectionClass].
			nameMatches & typeMatches & collectionTypeMatches]
		ifNone: [self newAttributeNamed: aSymbol type: aClass]