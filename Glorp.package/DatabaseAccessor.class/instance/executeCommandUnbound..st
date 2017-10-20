executing
executeCommandUnbound: aCommand
	| cursor |
	self logCommand: aCommand bound: false.
	cursor := self basicExecuteSQLString: aCommand sqlString.
	cursor command: aCommand.
	^cursor.