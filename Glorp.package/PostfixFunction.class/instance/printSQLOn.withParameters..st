printing
printSQLOn: aStream withParameters: aDictionary
	
	base printSQLOn: aStream withParameters: aDictionary.
	self printsIntoJoins ifFalse: [^self].
	aStream nextPutAll: ' '; nextPutAll: function.