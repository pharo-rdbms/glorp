database-specific
printOffset: anInteger on: aCommand
	"SQLite cannot have an offset without a limit.  A negative limit is treated as an infinite limit.  We cannot set it as an actual limit value;  that would hit limitMakesSense optimisation and abort the trip to the database.  So we add it here."

	aCommand query hasLimit ifFalse:
		[self printPostLimit: -1 on: aCommand].
	aCommand nextPutAll: ' OFFSET '.
	anInteger printOn: aCommand.