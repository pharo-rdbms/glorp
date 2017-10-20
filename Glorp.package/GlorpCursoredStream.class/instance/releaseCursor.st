initializing
releaseCursor
	
	self accessor isNil
		ifFalse:
			[self accessor releaseCursor: cursor in: statement.
			self accessor completedCommand: command].