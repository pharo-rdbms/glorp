printing
printOn: aStream

	aStream nextPutAll: 'a Login('.
	database printOn: aStream.
	aStream nextPutAll: ', '.
	username printOn: aStream.
	aStream nextPutAll: ', '.
	connectString printOn: aStream.
	aStream nextPutAll: ', '.
	schema printOn: aStream.
	aStream nextPutAll: ')'.