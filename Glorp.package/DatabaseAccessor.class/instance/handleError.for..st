executing
handleError: exception for: command
	| errorClass error |
	errorClass := command isReadCommand
		ifTrue: [GlorpDatabaseReadError]
		ifFalse: [GlorpDatabaseWriteError].
	error := errorClass new.
	error command: command.
	error databaseError: (self innerExceptionFor: exception).
	error accessor: self.
	error signal = true
		ifTrue:
			[self reset.
			self logout.
			self login.
			exception restart]
		ifFalse: [error return: nil].