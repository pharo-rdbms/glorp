private
reserveViaTableSelect: anInteger in: aSession for: aTable
	"In Oracle, there can be performance issues selecting against our tables, which we don't seem to get if we just use SYS.ALLOBJECTS. I'm suspicious the problem is if we have fragmentation of the file containing the table, but regardless, ALLOBJECTS seems consistently fast, so always use it"
	self reserveViaBackupMechanism: anInteger in: aSession.

"	| rows command |
	command := self
		tableSelectCommandFor: aTable
		in: aSession
		reserving: anInteger.
	command parameters: (Array with: anInteger).
	rows := aSession accessor executeCommand: command.
	rows do: [:each | self reservedNumbers add: each first]."