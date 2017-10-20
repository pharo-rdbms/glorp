querying
hasObjectExpiredOfClass: aClass withKey: key
	| cache |
	cache := self cacheForClass: aClass.
	^cache hasExpired: key.