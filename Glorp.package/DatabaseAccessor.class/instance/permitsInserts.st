permissions
permitsInserts
	deniedCommands isNil ifTrue: [^true].
	^(deniedCommands includes: InsertCommand) not.