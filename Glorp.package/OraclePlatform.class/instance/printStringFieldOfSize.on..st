table creation
printStringFieldOfSize: anInteger on: aStream

	aStream 
		nextPutAll: 'varchar2('.
	anInteger printOn: aStream.
	aStream nextPutAll: ')'.