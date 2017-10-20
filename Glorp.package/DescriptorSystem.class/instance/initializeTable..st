private
initializeTable: newTable
	| initializerName |
	initializerName := ('tableFor' , (newTable name asUppercase) , ':') asSymbol.
	(self respondsTo: initializerName)
		ifTrue: [self perform: initializerName with: newTable]
		ifFalse: [self noTableInitializerFound: newTable].
	newTable postInitializeIn: self.
	self deferentialSetSchema: newTable.