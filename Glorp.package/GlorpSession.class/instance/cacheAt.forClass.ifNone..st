caching
cacheAt: aKey  forClass: aClass ifNone: failureBlock

	^cache lookupClass: aClass key: aKey ifAbsent: failureBlock