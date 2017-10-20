private
reserveViaBackupMechanism: anInteger in: aSession
	"The regular mechanism didn't work, (probably because there weren't enough rows in the table), try a different technique. Oracle doesn't repeatedly evaluate nextval if we do it multiple times on a line, so instead guess at a table we know should have lots of rows in Oracle and use it"

	| rows command |
	command := self backupReserveCommand: anInteger in: aSession.
	command blockFactor: anInteger.
	rows := aSession accessor executeCommand: command.
	rows do: [:each | self reservedNumbers add: each first].