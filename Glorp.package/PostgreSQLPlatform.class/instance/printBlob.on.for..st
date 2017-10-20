conversion-strings
printBlob: aByteArray on: aStream for: aType

	aByteArray isNil ifTrue: [^aStream nextPutAll: 'NULL'].
	self hexPrintBlob: aByteArray on: aStream for: aType

