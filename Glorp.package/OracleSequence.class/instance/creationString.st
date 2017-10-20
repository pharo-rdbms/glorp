public
creationString
	^self sequenceIncrement > 1
		ifFalse: ['create sequence ', self qualifiedName]
		ifTrue: ['create sequence ', self qualifiedName, ' increment by ', self sequenceIncrement printString]