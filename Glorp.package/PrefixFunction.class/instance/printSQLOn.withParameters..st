printing
printSQLOn: aStream withParameters: aDictionary
	self printsIntoJoins
		ifTrue: [self printBasicSQLOn: aStream withParameters: aDictionary forSelect: false]
		ifFalse: [base printSQLOn: aStream withParameters: aDictionary].