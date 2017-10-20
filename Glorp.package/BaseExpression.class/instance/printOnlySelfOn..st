printing
printOnlySelfOn: aStream 
	self descriptor isNil ifTrue: [aStream nextPutAll: 'Empty Base'. ^self].
	aStream print: self descriptor describedClass.
	self printTableAliasesOn: aStream