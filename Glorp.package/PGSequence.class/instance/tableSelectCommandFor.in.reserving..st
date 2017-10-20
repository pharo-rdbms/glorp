SQL
tableSelectCommandFor: aTable in: aSession reserving: anInteger
	| stream |
	(tableSelectCommand notNil and: [tableSelectCommand parameters includes: anInteger]) ifFalse:
			[stream := WriteStream on: (String new: 200).
			stream nextPutAll: 'select nextval('.
			self qualifiedName printOn: stream.
			stream nextPutAll: ') from ' , aTable name.
			stream nextPutAll: ' limit '.
			stream nextPutAll: (aSession useBinding ifTrue: ['?'] ifFalse: [anInteger printString]).
			tableSelectCommand := SQLStringSelectCommand new.
			tableSelectCommand parameters: (Array with: anInteger).
			tableSelectCommand setSQLString: stream contents.
			tableSelectCommand session: aSession].
	^tableSelectCommand.