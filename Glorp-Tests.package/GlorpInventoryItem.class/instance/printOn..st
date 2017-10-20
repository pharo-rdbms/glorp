printing
printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: id printString.
	aStream nextPut: $,.
	aStream nextPutAll: name printString.
	aStream nextPut: $).