conversion-times
printTimestamp: aTimestampString on: stream for: aType

	aTimestampString isNil ifTrue: [stream nextPutAll: 'NULL'. ^self].
	stream nextPut: $'.
	aTimestampString printOn: stream.
	stream nextPut: $'.