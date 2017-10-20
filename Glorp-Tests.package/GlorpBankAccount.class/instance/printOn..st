printing
printOn: aStream

	super printOn: aStream.
	aStream 
		nextPutAll: '(id=';
		print: id;
		nextPut: $).