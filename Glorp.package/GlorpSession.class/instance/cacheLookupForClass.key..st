caching
cacheLookupForClass: aClass key: aKey 
	^self 
		cacheAt: aKey
		forClass: aClass
		ifNone: [nil]