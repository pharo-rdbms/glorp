caching
cacheRemoveObject: anObject
	| key |
	key := (self descriptorFor: anObject) primaryKeyFor: anObject.
	cache removeClass: anObject class key: key ifAbsent: []