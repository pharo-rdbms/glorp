printing
printStatementOn: aStream
	aStream nextPut: $(.
	fields do: [ :f | aStream nextPutAll: f name; nextPut: $, ].
	aStream skip: -1; nextPut: $)