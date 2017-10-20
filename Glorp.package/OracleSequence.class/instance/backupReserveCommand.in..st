private
backupReserveCommand: anInteger in: aSession
	| command stream |
	stream := WriteStream on: (String new: 200).
	stream nextPutAll: 'select '.
	stream nextPutAll: self qualifiedName.
	stream nextPutAll: '.nextval from SYS.ALL_OBJECTS '.
	stream nextPutAll: ' WHERE rownum <= '.
	stream
		nextPutAll:
			(aSession useBinding ifTrue: ['?'] ifFalse: [anInteger printString]).
	command := SQLStringSelectCommand new.
	command setSQLString: stream contents.
	command parameters: (Array with: anInteger).
	command session: aSession.
	^command.