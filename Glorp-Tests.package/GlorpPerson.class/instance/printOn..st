printing
printOn: aStream

	super printOn: aStream.
	aStream nextPutAll: '('.
	aStream nextPutAll: id printString, ',', (name ifNil: ['']).
	aStream nextPutAll: ')'.