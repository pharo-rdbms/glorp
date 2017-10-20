database-specific
printOffset: anInteger on: aCommand
	"MySQL cannot have an offset without a limit.  A very large number, like 256T, is equivalent to an infinite limit. We only print it here if there is no limit, but there is an offset."

	aCommand query hasLimit ifFalse:
		[self printPostLimit: SmallInteger maxVal on: aCommand].
	aCommand nextPutAll: ' OFFSET '.
	anInteger printOn: aCommand.