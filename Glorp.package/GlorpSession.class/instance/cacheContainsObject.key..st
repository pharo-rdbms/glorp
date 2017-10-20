caching
cacheContainsObject: anObject key: aKey 
	"Just test containment, don't return the result or trigger anything due to expiration"
	aKey isNil ifTrue: [^false].
	^cache
		containsObject: anObject
		key: aKey