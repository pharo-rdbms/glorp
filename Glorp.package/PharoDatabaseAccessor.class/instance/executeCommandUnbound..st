executing
executeCommandUnbound: aCommand
	| answerStream |
	self log: aCommand sqlString.
	answerStream := self basicExecuteSQLString: aCommand sqlString.
	^self cursorFor: answerStream command: aCommand.