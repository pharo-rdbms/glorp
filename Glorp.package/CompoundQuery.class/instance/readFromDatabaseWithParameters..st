executing
readFromDatabaseWithParameters: anArray
	| answerStream result |
	answerStream := self rowsFromDatabaseWithParameters: anArray.
	^self readsOneObject
		ifTrue: [result := answerStream next. answerStream release. result]
		ifFalse: [self resultCollectionFor: answerStream]