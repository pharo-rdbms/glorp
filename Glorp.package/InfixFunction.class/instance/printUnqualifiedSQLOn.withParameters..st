printing
printUnqualifiedSQLOn: aStream withParameters: aDictionary
	base printUnqualifiedSQLOn: aStream withParameters: aDictionary.
	self functionParts with: arguments do: [:functionPart :arg |
		aStream 
			nextPut: $ ;
			nextPutAll: functionPart;
			nextPut: $ .
		arg printUnqualifiedSQLOn: aStream withParameters: aDictionary].