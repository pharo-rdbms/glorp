initialize-release
cacheForClass: aClass
	^subCaches at: aClass
		ifAbsentPut: [self makeCacheFor: aClass]