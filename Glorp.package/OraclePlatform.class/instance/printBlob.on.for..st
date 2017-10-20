conversion-strings
printBlob: aByteArray on: aStream for: aType
	aByteArray isNil ifTrue: [^aStream nextPutAll: 'NULL'].
	aStream nextPutAll: 'HEXTORAW('''.
	aByteArray do: [:each |
		each printOn: aStream paddedWith: $0 to: 2 base: 16].
	aStream nextPutAll: ''')'.