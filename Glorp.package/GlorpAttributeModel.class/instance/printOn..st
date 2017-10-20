printing
printOn: aStream
	aStream nextPutAll: self classModel printString, '>>', self name