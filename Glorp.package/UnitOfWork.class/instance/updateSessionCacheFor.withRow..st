private/mapping
updateSessionCacheFor: anObject withRow: aRow 
	| key |
	(rowMap isRowMapKey: anObject) ifTrue: [^self].  "Not cachable"
	key := aRow primaryKey.
	key isNil ifTrue: [^self].
	(session cacheContainsObjectForClass: anObject class key: key) 
		ifFalse: [self addObject: anObject toCacheKeyedBy: key]