caching
cacheContainsObject: anObject
	| descriptor key |
	(descriptor := self descriptorFor: anObject) isNil ifTrue: [^false].
	(key := descriptor primaryKeyFor: anObject) isNil ifTrue: [^false].
	^[self cacheContainsObject: anObject key: key] on: DuplicatePrimaryKeyException do: [:ex | false]