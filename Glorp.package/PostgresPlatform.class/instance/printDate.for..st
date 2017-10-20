conversion-times
printDate: aDate for: aType
	"Print a date (or timestamp) as yyyy-mm-dd"
	| stream |
	aDate isNil ifTrue: [^'NULL'].
	stream := WriteStream on: String new.
	stream nextPut: $'.
	self
		printDate: aDate
		isoFormatOn: stream.
	stream nextPut: $'.
	^stream contents.