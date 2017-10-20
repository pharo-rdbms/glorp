instance creation
named: aSymbol dictionary: dictionaryClass from: keyClass to: valueClass
	^(self new)
		name: aSymbol;
		type: valueClass;
		keyType: keyClass;
		collectionType: dictionaryClass