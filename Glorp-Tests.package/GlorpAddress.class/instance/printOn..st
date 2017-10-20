printing
printOn: aStream

	super printOn: aStream.
	aStream nextPutAll: '(', id printString, ',', street printString, ',' , number printString, ')'.