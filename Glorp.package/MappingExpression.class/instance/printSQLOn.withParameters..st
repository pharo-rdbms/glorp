printing SQL
printSQLOn: aStream withParameters: aDictionary 
	self hasField ifFalse: [^self].
	self field asField printSQLOn: aStream withParameters: aDictionary.