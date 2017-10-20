printing
printTreeOn: aStream
	aStream nextPutAll: 'subselect('.
	query printOn: aStream.
	aStream nextPutAll: ')'.