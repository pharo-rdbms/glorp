conversion-strings
printBlob: aByteArray on: aStream for: aType
	aByteArray isNil ifTrue: [^aStream nextPutAll: 'NULL'].
	aStream nextPutAll: '0x'.
	aByteArray do: [:each |
		each printOn: aStream paddedWith: $0 to: 2 base: 16].