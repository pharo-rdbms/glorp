printing
printOnlySelfOn: aStream 
	base printsTable
		ifTrue: [field printUnqualifiedSQLOn: aStream withParameters: #()]
		ifFalse: [field printSQLOn: aStream withParameters: #()]