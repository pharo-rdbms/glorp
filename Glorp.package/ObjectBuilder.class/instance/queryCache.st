accessing
queryCache
	queryCache isNil ifTrue: [queryCache := IdentityDictionary new: 5].
	^queryCache.