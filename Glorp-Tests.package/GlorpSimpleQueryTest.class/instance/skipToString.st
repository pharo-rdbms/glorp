tests
skipToString
	^session platform supportsANSIJoins ifTrue: ['join '] ifFalse: ['where '].