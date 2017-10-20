printing
printOn: aStream
	super printOn: aStream.
	aStream nextPutAll: '('.
	aStream nextPutAll: items size printString.
	aStream nextPut: $/.
	aStream nextPutAll: maximumSize printString.
	aStream nextPutAll: ')'