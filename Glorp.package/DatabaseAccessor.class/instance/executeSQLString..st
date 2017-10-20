executing
executeSQLString: aString
	| result block time |
	self log: aString.
	block := [result := (self basicExecuteSQLString: aString) upToEnd].
	time := self logging
		ifTrue: [Time millisecondsToRun: block]
		ifFalse:
			[block value.
			0].
	self logTime: time.
	^result.