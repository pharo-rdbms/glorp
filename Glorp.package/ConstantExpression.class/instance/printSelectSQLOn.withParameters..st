printing
printSelectSQLOn: aStream withParameters: aDictionary
	self value glorpPrintSelectSQLOn: aStream.
	alias notNil ifTrue: [
		aStream 
			nextPutAll: ' AS ';
			nextPutAll: alias].