printing
printSelectSQLOn: aStream withParameters: aDictionary
	self printSQLOn: aStream withParameters: aDictionary.
	alias notNil ifTrue: [aStream nextPutAll: ' AS '; nextPutAll: alias].