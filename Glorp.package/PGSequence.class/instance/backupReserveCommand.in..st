private
backupReserveCommand: anInteger in: aSession
	| stream command |
	stream := WriteStream on: (String new: 200).
	stream nextPutAll: 'select '.
	GlorpHelper
		print: [:i | 'nextval(''' , self qualifiedName , ''')']
		on: stream
		for: (1 to: anInteger)
		separatedBy: ','.
	command := SQLStringSelectCommand new.
	command setSQLString: stream contents.
	command parameters: (Array with: anInteger).
	command session: aSession.
	^command.