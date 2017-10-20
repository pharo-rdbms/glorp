printing SQL
printUnqualifiedSQLOn: aStream withParameters: aDictionary 
	self field asField printUnqualifiedSQLOn: aStream withParameters: aDictionary.