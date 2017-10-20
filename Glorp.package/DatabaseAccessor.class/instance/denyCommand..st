permissions
denyCommand: aCommand
	(aCommand isBehavior) ifFalse: [self error: 'invalid command type'].
	self denyCommands: (Array with: aCommand).