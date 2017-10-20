permissions
permitNothingDuring: aBlock
	| oldCommands |
	oldCommands := self deniedCommands.
	self permitNothing.
	aBlock ensure: [deniedCommands := oldCommands].