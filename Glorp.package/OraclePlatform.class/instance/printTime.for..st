conversion-times
printTime: aTime for: aType
	| stream |
	aTime isNil ifTrue: [^'NULL'].
	stream := WriteStream on: String new.
	stream nextPutAll: 'to_date('''.
	self
		printTime: aTime
		isoFormatOn: stream.
	stream nextPutAll: ''','''.
	stream nextPutAll: 'HH24:MI:SS'.
	stream nextPutAll: ''')'.
	^stream contents.