executing
executeCommandBound: aCommand
	| answerStream |
	self logCommand: aCommand bound: true.
	self useBinding ifFalse: [ ^ self executeCommandUnbound: aCommand  ].
	
	answerStream := self databaseDriver 
									basicExecuteSQLString: aCommand sqlString 
									binding: aCommand bindings.
									
	^ self cursorFor: answerStream command: aCommand.
	