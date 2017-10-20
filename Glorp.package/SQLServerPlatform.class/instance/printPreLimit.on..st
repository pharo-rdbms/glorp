database-specific
printPreLimit: anInteger on: aCommand
	aCommand
		nextPutAll: ' TOP '.
	anInteger printOn: aCommand.
	aCommand nextPutAll: ' '.