executing
readFromDatabaseWithParameters: anArray
	| answerStream result |
	answerStream := self rowsFromDatabaseWithParameters: anArray.
	^readsOneObject
		ifTrue: [result := answerStream next. answerStream release. result]
		ifFalse: [self resultCollectionFor: answerStream]