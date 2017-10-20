printing
printOn: aStream
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: (name isNil ifTrue: ['unnamed'] ifFalse: [name]);
		nextPut: $).