conversion-strings
printBlob: aByteArray on: aStream for: aType
	aByteArray isNil ifTrue: [^aStream nextPutAll: 'NULL'].
	Dialect isSqueak ifTrue: [^self squeakPrintBlob: aByteArray on: aStream for: aType].
	aStream nextPutAll: (self encodeAsBase64String: aByteArray) printString