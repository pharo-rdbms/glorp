printing
printOn: aStream
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: id printString;
		nextPutAll: ', ';
		nextPutAll: (name ifNil: [name printString]);
		nextPut: $);
		cr