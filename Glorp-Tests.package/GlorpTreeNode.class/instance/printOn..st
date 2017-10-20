printing
printOn: aStream
	aStream nextPutAll: 'Node('.
	id printOn: aStream.
	aStream nextPut: $).