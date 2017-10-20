printing
printStatementOn: aStream platform: aPlatform
	"Some platforms need to quote some column names."

	aStream nextPut: $(.
	fields do: [ :f | aStream nextPutAll: (aPlatform nameForColumn: f name); nextPut: $, ].
	aStream skip: -1; nextPut: $)