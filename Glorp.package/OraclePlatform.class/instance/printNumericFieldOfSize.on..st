table creation
printNumericFieldOfSize: anInteger on: aStream

	aStream 
		nextPutAll: 'number('.
	anInteger printOn: aStream.
	aStream nextPutAll: ')'.