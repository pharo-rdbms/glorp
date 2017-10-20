printing
printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: (name isNil ifTrue: [''] ifFalse: [name]).
	aStream nextPut: $).