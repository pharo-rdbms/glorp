printing
printTreeOn: aStream 
	aStream
		nextPutAll: function, '('.
	base printOn: aStream.
	aStream nextPutAll: ')'.