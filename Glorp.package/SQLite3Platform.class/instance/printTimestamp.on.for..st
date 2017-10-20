conversion-times
printTimestamp: aTimestampString on: stream for: aType
	"SQLite does not suppport any time-related types.  We convert them all to strings via the to... methods, so parameters to this method should be Strings of the form '1959-03-27 10:20:23'."

	aTimestampString isNil ifTrue: [stream nextPutAll: 'NULL'. ^self].
	"The next line is checking code and can be dropped when SQLite is sufficiently tested."
	aTimestampString class = Dialect timestampClass ifTrue: [self error: 'SQLite does not support timestamp types;  this should have been a String'].
	stream nextPut: $'.
	stream nextPutAll: aTimestampString.
	stream nextPut: $'.