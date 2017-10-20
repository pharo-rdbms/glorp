conversion-times
printTime: aTime for: aType
	| stream |
	aTime isNil ifTrue: [^'NULL'].
	stream := WriteStream on: String new.
	stream nextPut: $".
	self
		printTime: aTime
		isoFormatOn: stream
		milliseconds: false.
	stream nextPut: $".
	^stream contents.