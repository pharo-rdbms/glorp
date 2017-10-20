sql generation
printTablesOn: aCommand
	aCommand
		cr;
		nextPutAll: ' FROM '.
	self useANSIJoins
		ifTrue: [self printANSITablesOn: aCommand]
		ifFalse: [self printNormalTablesOn: aCommand]