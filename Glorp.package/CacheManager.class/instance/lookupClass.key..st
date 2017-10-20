querying
lookupClass: aClass key: aKey

	^self lookupClass: aClass key: aKey ifAbsent: [self error: 'cache miss'].