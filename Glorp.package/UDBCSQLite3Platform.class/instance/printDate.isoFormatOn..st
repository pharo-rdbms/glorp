conversion-times
printDate: aTimestamp isoFormatOn: stream
	"Print the date as yyyy-mm-dd"
	| monthNumber dayOfMonth |
	aTimestamp isNil ifTrue: [^'NULL'].
	stream nextPut: $".
	aTimestamp year printOn: stream.
	stream nextPut: $-.
	monthNumber := aTimestamp monthIndex.
	stream nextPutAll: (GlorpDatabaseType padToTwoDigits: monthNumber).
	stream nextPut: $-.
	dayOfMonth := aTimestamp dayOfMonth.
	stream nextPutAll: (GlorpDatabaseType padToTwoDigits: dayOfMonth).
	stream nextPut: $".
