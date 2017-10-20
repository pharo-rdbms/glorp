conversion-times
printTime: aTime for: aType
	"Print a time (or timestamp) as hh:mm:ss.fff"
	| stream |
	aTime isNil ifTrue: [^'NULL'].
	stream := WriteStream on: String new.
	stream nextPut: $'.
	self
		printTime: aTime
		isoFormatOn: stream.
	stream nextPut: $'.
	^stream contents.