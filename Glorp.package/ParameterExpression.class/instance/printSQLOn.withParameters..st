printing
printSQLOn: aStream withParameters: aDictionary
	self field type print: (self valueIn: aDictionary) on: aStream.