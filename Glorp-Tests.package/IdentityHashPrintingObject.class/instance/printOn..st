printing
printOn: aStream
	aStream nextPutAll: 'thing with hash '.
	self identityHash printOn: aStream.