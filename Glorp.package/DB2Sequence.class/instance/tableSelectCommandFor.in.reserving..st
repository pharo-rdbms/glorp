SQL
tableSelectCommandFor: aTable in: aSession reserving: anInteger
	"Don't bind the number in the fetch first nn clause."
	| stream |
	(tableSelectCommand notNil and: [tableSelectCommand parameters includes: anInteger]) ifFalse:
			[stream := WriteStream on: (String new: 200).
			stream nextPutAll: 'select next value for '.
			stream nextPutAll: self qualifiedName.
			stream nextPutAll: ' from '.
			stream nextPutAll: aTable name.
			stream nextPutAll: ' fetch first '.
			stream nextPutAll: anInteger printString.
			stream nextPutAll: ' rows only'.
			tableSelectCommand := SQLStringSelectCommand new.
			tableSelectCommand parameters: (Array with: anInteger).
			tableSelectCommand setSQLString: stream contents.
			tableSelectCommand blockFactor: anInteger.
			tableSelectCommand session: aSession].
	^tableSelectCommand.