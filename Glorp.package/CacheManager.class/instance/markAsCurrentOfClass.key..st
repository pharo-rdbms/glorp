querying
markAsCurrentOfClass: aClass key: key
	| cache |
	aClass == Proxy ifTrue: [^self].
	cache := self cacheForClass: aClass.
	cache markAsCurrentAtKey: key.