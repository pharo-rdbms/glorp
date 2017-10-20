printing
printSQLOn: aStream withParameters: anArray 
	aStream nextPutAll: self quotedQualifiedName.