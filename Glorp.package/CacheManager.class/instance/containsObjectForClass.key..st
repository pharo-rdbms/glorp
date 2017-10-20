querying
containsObjectForClass: aClass key: aKey

	| cache |
	cache := self cacheForClass: aClass.
	^cache includesKey: aKey.