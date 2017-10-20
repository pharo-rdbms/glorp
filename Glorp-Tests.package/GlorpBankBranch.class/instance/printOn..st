printing
printOn: aStream
	super printOn: aStream.
	aStream nextPutAll: '(', self branchNumber printString, ')'.