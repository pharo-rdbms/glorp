database-specific
printOffset: anInteger on: aCommand
	aCommand
		nextPutAll: ' OFFSET '.
	anInteger printOn: aCommand.