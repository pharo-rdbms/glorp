querying
removeClass: aClass key: aKey

	^self removeClass: aClass key: aKey ifAbsent: [self error: 'Object not in cache'].