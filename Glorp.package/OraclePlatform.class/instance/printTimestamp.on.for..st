conversion-times
printTimestamp: aTimestamp on: stream for: aType
	aTimestamp isNil ifTrue: [stream nextPutAll: 'NULL'. ^self].
	stream nextPutAll: 'to_date('''.
	self
		printDate: aTimestamp
		isoFormatOn: stream.
	stream nextPut: $ .
	self
		printTime: aTimestamp
		isoFormatOn: stream
		milliseconds: false.
	stream nextPutAll: ''','''.
	stream nextPutAll: 'YYYY-MM-DD HH24:MI:SS'.
	stream nextPutAll: ''')'.