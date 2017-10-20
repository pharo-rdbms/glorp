printing
printTreeOn: aStream 
	base printOn: aStream.
	aStream nextPut: $..
	table printSQLOn: aStream withParameters: #()