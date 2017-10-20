permissions
alsoDenyCommand: aCommand
	self deniedCommands isNil
		ifTrue: [self denyCommand: aCommand]
		ifFalse:
			[self deniedCommands: self deniedCommands , (Array with: aCommand)].