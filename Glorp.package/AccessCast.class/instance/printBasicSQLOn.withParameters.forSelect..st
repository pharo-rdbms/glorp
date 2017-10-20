printing
printBasicSQLOn: aStream withParameters: aDictionary forSelect: aBoolean
	aStream
		nextPutAll: self castFunctionName;
		nextPut: $(.
	aBoolean
		ifTrue: [base printSelectSQLOn: aStream withParameters: aDictionary]
		ifFalse: [base printSQLOn: aStream withParameters: aDictionary].
	aStream nextPut: $).
	alias notNil
		ifTrue:
			[aStream
				nextPutAll: ' AS ';
				nextPutAll: alias].