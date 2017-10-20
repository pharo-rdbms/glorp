private/mapping
collectionMementoFor: aCollection

	aCollection glorpIsCollection ifFalse: [^aCollection].
	^collectionMementos at: aCollection ifAbsent: [correspondenceMap at: aCollection]