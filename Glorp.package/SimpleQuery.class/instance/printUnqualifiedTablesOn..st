sql generation
printUnqualifiedTablesOn: aCommand
	aCommand
		cr;
		nextPutAll: ' FROM '.
	self printUnqualifiedNormalTablesOn: aCommand.