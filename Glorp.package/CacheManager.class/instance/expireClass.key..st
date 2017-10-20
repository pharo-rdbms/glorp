querying
expireClass: aClass key: aKey

	^self expireClass: aClass key: aKey ifAbsent: [self error: 'Object not in cache'].