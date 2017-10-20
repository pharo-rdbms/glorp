SQL
reserveViaBackupMechanism: anInteger in: aSession
	"The regular mechanism didn't work, (probably because there weren't enough rows in the table), try a different technique."

	| command row |
	command := self backupReserveCommand: anInteger in: aSession.
	row := (aSession accessor executeCommand: command) first.
	self reservedNumbers addAll: row.