querying
containsObject: anObject key: aKey

	| cache |
	cache := self cacheForClass: anObject class.
	^cache includesKey: aKey as: anObject.