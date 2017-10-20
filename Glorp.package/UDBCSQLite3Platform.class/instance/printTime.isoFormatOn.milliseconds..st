conversion-times
printTime: aTimestamp isoFormatOn: stream milliseconds: aBoolean
	"Print the time as hh:mm:ss.mmm"
	| ms |
	aTimestamp isNil ifTrue: [^nil].
	stream nextPut: $".
	stream nextPutAll: (GlorpDatabaseType padToTwoDigits: aTimestamp hours).
	stream nextPut: $:.
	stream nextPutAll: (GlorpDatabaseType padToTwoDigits: aTimestamp minutes).
	stream nextPut: $:.
	stream nextPutAll: (GlorpDatabaseType padToTwoDigits: aTimestamp seconds).
	aBoolean ifFalse: [^self].
	Dialect supportsMillisecondsInTimes ifFalse: [ ^self ].
	ms := aTimestamp milliseconds.
	ms = 0 ifTrue: [^self].
	stream nextPut: $..
	stream nextPutAll: (GlorpDatabaseType padToThreeDigits: ms).	
	stream nextPut: $".
