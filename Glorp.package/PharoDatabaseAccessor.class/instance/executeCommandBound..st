executing
executeCommandBound: aCommand
	| cursor |
	self logCommand: aCommand bound: true.
	cursor := (self useBinding)
				ifFalse: [ self basicExecuteSQLString: aCommand sqlString ]
				ifTrue: [ self databaseDriver basicExecuteSQLString: aCommand sqlString binding: aCommand bindings ].
	cursor command: aCommand.
	aCommand needsRowCount ifTrue: [
		aCommand rowCount: (self platform supportsRowCount
									ifTrue: [cursor rowCount]
									ifFalse: [1])].
	^cursor.
	