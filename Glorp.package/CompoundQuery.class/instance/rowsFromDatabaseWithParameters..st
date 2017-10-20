executing
rowsFromDatabaseWithParameters: anArray
	^session accessor
		executeCommand: (self sqlWith: anArray)
		returnCursor: true