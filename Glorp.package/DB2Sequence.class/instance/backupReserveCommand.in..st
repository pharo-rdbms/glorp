private
backupReserveCommand: anInteger in: aSession
	"syscat.tables is a public view of all the tables.
	Don't bind the number in the fetch first nn clause."

	| command stream |
	stream := WriteStream on: (String new: 200).
	stream nextPutAll: 'select next value for '.
	stream nextPutAll: self qualifiedName.
	stream nextPutAll: ' from SYSCAT.TABLES'.
	stream nextPutAll: ' fetch first '.
	stream nextPutAll: anInteger printString.
	stream nextPutAll: ' rows only'.
	command := SQLStringSelectCommand new.
	command setSQLString: stream contents.
	command parameters: (Array with: anInteger).
	command session: aSession.
	^command.