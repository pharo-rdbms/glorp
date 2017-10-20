printing SQL
printSelectSQLOn: aStream withParameters: aDictionary 
	self hasField ifFalse: [^self].
	self field asField printSelectSQLOn: aStream withParameters: aDictionary.