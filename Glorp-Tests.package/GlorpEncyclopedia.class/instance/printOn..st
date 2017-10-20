accessing
printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(.
	name isNil ifFalse: [aStream nextPutAll: name].
	aStream nextPut: $).