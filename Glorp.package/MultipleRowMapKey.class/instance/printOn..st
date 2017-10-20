printing
printOn: aStream
	aStream nextPutAll: 'KEY('.
	self hash printOn: aStream.
	aStream nextPutAll: '):'.
	keys printOn: aStream