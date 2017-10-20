printing
printOn: aStream 
	super printOn: aStream.
	aStream
		nextPut: $(;
		print: id;
		nextPut: $,;
		nextPutAll: (name ifNil: ['']);
		nextPutAll: ')'