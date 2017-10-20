printing
printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(.
	title isNil ifFalse: [aStream nextPutAll: title].
	aStream nextPut: $).