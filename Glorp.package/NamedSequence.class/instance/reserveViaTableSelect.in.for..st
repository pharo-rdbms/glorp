SQL
reserveViaTableSelect: anInteger in: aSession for: aTable
	| rows command |
	command := self
		tableSelectCommandFor: (self tableToSelectFromIn: aSession for: aTable)
		in: aSession
		reserving: anInteger.
	command parameters: (Array with: anInteger).
	rows := aSession accessor executeCommand: command.
	rows do: [:each | self reservedNumbers add: each first].