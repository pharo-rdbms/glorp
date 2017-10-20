accessing
constantValueIn: aSession

	^valueIsSession
		ifTrue: [aSession]
		ifFalse: [constantValue].