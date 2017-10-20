accessing
collection: aCollection
	aCollection class == GlorpVirtualCollection ifTrue: [collectionType := aCollection getQuery collectionType].
	collection := aCollection