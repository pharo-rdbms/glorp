api
tableNamed: aString

	^self tableNamed: aString ifNone: [NoTableFound new parameter: aString; signal]