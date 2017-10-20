querying
hasExpired: aClass key: key
	| cache |
	cache := self cacheFor: aClass.
	^cache hasExpired: key.