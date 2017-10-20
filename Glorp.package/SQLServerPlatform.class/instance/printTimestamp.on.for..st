conversion-times
printTimestamp: aTimestamp on: stream for: aType
	aTimestamp isNil ifTrue: [stream nextPutAll: 'NULL'. ^self].
	stream nextPutAll: '{ ts '''.
	self
		printDate: aTimestamp
		isoFormatOn: stream.
	stream nextPutAll: ' '.
	self
		printTime: aTimestamp
		isoFormatOn: stream.
	stream nextPutAll: ''' }'.