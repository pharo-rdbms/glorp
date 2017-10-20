permissions
checkPermissionFor: command
	deniedCommands isNil ifTrue: [^self].
	(deniedCommands includes: command class)
		ifTrue: [(GlorpIllegalCommand new command: command) signal].