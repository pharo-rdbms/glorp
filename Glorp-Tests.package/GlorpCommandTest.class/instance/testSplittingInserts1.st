tests
testSplittingInserts1
	| rows command subCommands |
	rows := Array with: DatabaseRow new.
	command := InsertCommand forRows: rows useBinding: false session: nil.
	subCommands := command subCommands.
	self assert: subCommands size = 1.
	self assert: subCommands first allRows size = 1.
	self assert: subCommands first allRows first == rows first.