printing
printOperationOn: aCommand
	aCommand space.
	aCommand nextPutAll: (self platform compoundOperationFor: operation).
	aCommand space