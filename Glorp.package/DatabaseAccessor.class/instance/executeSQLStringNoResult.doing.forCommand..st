executing
executeSQLStringNoResult: aString doing: aBlock forCommand: aCommand
	"Execute the string and discard the result. Evaluate aBlock before releasing the statement's answer stream"

	| block time |
	aCommand isNil ifTrue: [self log: aString] ifFalse: [self logCommand: aCommand bound: false].
	block := [self basicExecuteSQLStringNoResult: aString doing: aBlock].
	time := self logging
		ifTrue: [Time millisecondsToRun: block]
		ifFalse:
			[block value.
			0].
	self logTime: time.