instance creation
on: aStream for: aCommand accessor: aDatabaseAccessor
	^(self on: aStream)
		command: aCommand;
		databaseAccessor: aDatabaseAccessor