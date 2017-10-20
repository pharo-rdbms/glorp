printing
printBasicSQLOn: aStream withParameters: aDictionary forSelect: aBoolean
	aStream
		nextPutAll: function;
		nextPut: $(.
	aBoolean
		ifTrue: [base printSelectSQLOn: aStream withParameters: aDictionary]
		ifFalse: [base printSQLOn: aStream withParameters: aDictionary].
	arguments
		do:
			[:each | 
			"It's possible there needs to be type conversion here similar to InfixFunction>>printSQLOn:withParameters:, but it's not clear how common that case is, or how best to do it, so leaving it until it becomes a problem."
			aStream nextPutAll: separator.
			aBoolean 
				ifTrue: [each printSelectSQLOn: aStream withParameters: aDictionary]
				ifFalse: [each printSQLOn: aStream withParameters: aDictionary]].
	aStream nextPut: $).
	alias notNil
		ifTrue:
			[aStream
				nextPutAll: ' AS ';
				nextPutAll: alias].