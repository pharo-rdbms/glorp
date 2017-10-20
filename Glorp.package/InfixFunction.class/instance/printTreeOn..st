printing
printTreeOn: aStream 
	base printOn: aStream.
	aStream
		nextPutAll: ' ', function, ' '.
	arguments printOn: aStream.