printing
printBasicSQLOn: aStream withParameters: aDictionary forSelect: aBoolean

	^self ultimateBaseExpression system platform isPostgreSQLPlatform
		ifFalse: [ super printBasicSQLOn: aStream withParameters: aDictionary forSelect: aBoolean ]
		ifTrue: [
	aStream
		nextPutAll: function;
		nextPut: $(.
	aBoolean
		ifTrue: [base printSelectSQLOn: aStream withParameters: aDictionary]
		ifFalse: [base printSQLOn: aStream withParameters: aDictionary].
	aStream nextPutAll: ' from '.
	aBoolean 
		ifTrue: [ (arguments at: 1) printSelectSQLOn: aStream withParameters: aDictionary]
		ifFalse: [ (arguments at: 1) printSQLOn: aStream withParameters: aDictionary].
	aStream nextPutAll: ' for '.
	aBoolean 
		ifTrue: [ (arguments at: 2) printSelectSQLOn: aStream withParameters: aDictionary]
		ifFalse: [ (arguments at: 2) printSQLOn: aStream withParameters: aDictionary].
	aStream nextPut: $).
	alias notNil
		ifTrue:
			[aStream
				nextPutAll: ' AS ';
				nextPutAll: alias]].