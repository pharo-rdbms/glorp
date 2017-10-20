conversion-times
printDate: aDate for: aType
	"Print a date (or timestamp) as yyyy-mm-dd"
	| stream |
	aDate isNil ifTrue: [^'NULL'].
	stream := WriteStream on: String new.
	stream nextPutAll: '{ d '''.
	self
		printDate: aDate
		isoFormatOn: stream.
	stream nextPutAll: ''' }'.
	^stream contents.