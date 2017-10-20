printing
printTreeOn: aStream 
	base printOn: aStream.
	aStream nextPut: $..
	base printsTable 
		ifTrue: [field printUnqualifiedSQLOn: aStream withParameters: #()]
		ifFalse: [field printSQLOn: aStream withParameters: #()]