constants
reservedWords
	reservedWords isNil ifTrue: [self initializeReservedWords].
	^reservedWords.