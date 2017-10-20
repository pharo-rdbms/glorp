permissions
permitsUpdates
	deniedCommands isNil ifTrue: [^true].
	^(deniedCommands includes: UpdateCommand) not.