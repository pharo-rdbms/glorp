conversion-times
printDate: aDate for: aType
	| stream |
	aDate isNil ifTrue: [^'NULL'].
	stream := WriteStream on: String new.
	stream nextPutAll: 'to_date('''.
	self
		printDate: aDate
		isoFormatOn: stream.
	stream nextPutAll: ''','''.
	stream nextPutAll: 'YYYY-MM-DD'.
	stream nextPutAll: ''')'.
	^stream contents.