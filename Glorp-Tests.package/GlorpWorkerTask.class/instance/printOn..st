printing
printOn: aStream
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: id printString;
		nextPutAll: ', ';
		nextPutAll: (description ifNil: [description printString]);
		nextPut: $);
		cr