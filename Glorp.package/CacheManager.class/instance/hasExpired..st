querying
hasExpired: anObject
	| key cache |
	key := (session descriptorFor: anObject) primaryKeyFor: anObject.
	cache := self cacheFor: anObject.
	cache isNil ifTrue: [^false].  "We have an uninstantiated proxy."
	^cache hasExpired: key.