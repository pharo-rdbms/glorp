tests
testSplittingInserts1001
	| rows command subCommands |
	rows := (Array new: 1001) atAllPut: DatabaseRow new.
	rows at: rows size put: DatabaseRow new.
	command := InsertCommand forRows: rows useBinding: false session: nil.
	subCommands := command subCommands.
	self assert: subCommands size = 2.
	self assert: subCommands first allRows size = 1000.
	self assert: subCommands first allRows first == rows first.
	self assert: subCommands last allRows size = 1.
	self assert:subCommands last allRows first == rows last.