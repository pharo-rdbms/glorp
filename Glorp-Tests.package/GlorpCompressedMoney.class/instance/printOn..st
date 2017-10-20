printing
printOn: aStream

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: self amount;
		space;
		nextPutAll: self currency;
		nextPut: $).