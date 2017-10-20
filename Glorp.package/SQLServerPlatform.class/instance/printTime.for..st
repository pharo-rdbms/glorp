conversion-times
printTime: aTime for: aType
	"Print a time (or timestamp) as hh:mm:ss.fff"
	| stream |
	aTime isNil ifTrue: [^'NULL'].
	stream := WriteStream on: String new.
	stream nextPutAll: '{ t '''.
	self
		printTime: aTime
		isoFormatOn: stream
		milliseconds: self supportsMillisecondsInTimes.
	stream nextPutAll: ''' }'.
	^stream contents.