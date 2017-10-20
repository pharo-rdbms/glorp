caching
isRegistered: anObject

	currentUnitOfWork isNil ifTrue: [^false].
	^currentUnitOfWork isRegistered: anObject