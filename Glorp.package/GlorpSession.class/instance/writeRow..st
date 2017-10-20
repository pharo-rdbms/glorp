read/write
writeRow: aDatabaseRow
	| command success |
	aDatabaseRow shouldBeWritten ifFalse: [^true].
	aDatabaseRow preWriteAssignSequencesUsing: self.
	command := self commandForRow: aDatabaseRow.
	accessor executeCommand: command.
	success := true.
	command succeeded
		ifFalse:
			[success := (GlorpWriteFailure new)
				command: command;
				object: (Array with: aDatabaseRow owner);
				signal].
	^success.