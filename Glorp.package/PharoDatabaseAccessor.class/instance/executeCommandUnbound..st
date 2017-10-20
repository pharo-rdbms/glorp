executing
executeCommandUnbound: aCommand
	| answerStream |
	self log: aCommand sqlString.
	answerStream := self basicExecuteSQLString: aCommand sqlString.
	aCommand needsRowCount
		ifTrue:
			[aCommand
				rowCount:
					(self platform supportsRowCount
						ifTrue: [answerStream rowCount]
						ifFalse: [1])].
	^self cursorFor: answerStream command: aCommand.