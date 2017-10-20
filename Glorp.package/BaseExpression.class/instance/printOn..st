printing
printOn: aStream 
	aStream
		nextPutAll: self className;
		nextPut: $(.
	self printTreeOn: aStream.
	aStream nextPut: $)