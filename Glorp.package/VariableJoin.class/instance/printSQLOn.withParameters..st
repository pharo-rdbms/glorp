printing
printSQLOn: aStream withParameters: aDictionary 
	[aStream query] on: Error do: [:ex | ^super printOn: aStream].
	(joins at: aStream query resultClass) printSQLOn: aStream withParameters: aDictionary.