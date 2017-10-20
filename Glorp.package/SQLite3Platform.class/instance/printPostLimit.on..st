database-specific
printPostLimit: anInteger on: aCommand
	aCommand
		nextPutAll: ' LIMIT '.
	anInteger printOn: aCommand.