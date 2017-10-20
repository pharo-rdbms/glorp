printing
printOnlySelfOn: aStream

	aStream nextPutAll: name.
	self printTableAliasesOn: aStream.