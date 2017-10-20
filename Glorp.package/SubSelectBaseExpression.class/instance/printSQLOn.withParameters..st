printing
printSQLOn: aStream withParameters: aDictionary
	"If I'm ever going to print this directly, it's because I'm participating in a direct to-many relationship, so I do have a valid field"
	(self translateField: self field) printSQLOn: aStream withParameters: aDictionary.