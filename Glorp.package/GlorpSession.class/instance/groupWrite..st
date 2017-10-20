read/write
groupWrite: aCollectionOfDatabaseRows
	| command |
	aCollectionOfDatabaseRows
		do: [:each | each preWriteAssignSequencesUsing: self].
	command := self commandForHomogeneousRows: aCollectionOfDatabaseRows.
	accessor executeCommand: command.
	^command succeeded
		ifTrue: [true]
		ifFalse:
			[((GlorpWriteFailure new)
				command: command;
				object: (aCollectionOfDatabaseRows collect: [:each | each owner]))
				signal].