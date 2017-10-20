permissions
allowCommand: aCommand during: aBlock
	| oldCommands |
	oldCommands := self deniedCommands.
	((self deniedCommands ifNil: [#()]) includes: aCommand)
		ifTrue: [deniedCommands := deniedCommands copyWithout: aCommand].
	aBlock ensure: [deniedCommands := oldCommands].