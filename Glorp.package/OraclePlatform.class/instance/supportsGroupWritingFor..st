testing
supportsGroupWritingFor: aCommand
	^self supportsBinding and: [self useBinding and: [aCommand supportsGroupWriting]].