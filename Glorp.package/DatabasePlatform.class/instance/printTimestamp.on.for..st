conversion-times
printTimestamp: aTimestamp on: aStream for: aType
	aTimestamp isNil ifTrue: [aTimestamp glorpPrintSQLOn: aStream. ^self].

	aStream nextPut: $'; nextPutAll: aTimestamp printString; nextPut: $'.