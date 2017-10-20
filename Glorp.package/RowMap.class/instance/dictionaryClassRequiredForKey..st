private/mapping
dictionaryClassRequiredForKey: anObject

	^(self isRowMapKey: anObject)
		ifTrue: [Dictionary]
		ifFalse: [IdentityDictionary]