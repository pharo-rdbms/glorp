initialize-release
cacheForClass: aClass

	| classKey |
	classKey := (self system cacheKeyClassFor: aClass).
	^subCaches at:  classKey
		ifAbsentPut: [self makeCacheFor: classKey]