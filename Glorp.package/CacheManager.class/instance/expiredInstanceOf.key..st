private/caching
expiredInstanceOf: aClass key: aKey

	^(self cacheForClass: aClass) expiredInstanceFor: aKey.