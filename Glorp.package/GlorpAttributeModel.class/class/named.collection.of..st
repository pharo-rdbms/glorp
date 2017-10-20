instance creation
named: aSymbol collection: aCollectionClass of: aClass
	^(self new)
		name: aSymbol;
		type: aClass;
		collectionType: aCollectionClass