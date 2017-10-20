accessing
cachedQueryFor: aMapping
	^self queryCache at: aMapping ifAbsent: [nil]