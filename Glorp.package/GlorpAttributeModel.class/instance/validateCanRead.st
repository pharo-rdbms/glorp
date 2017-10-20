validation
validateCanRead
	self isReadable ifFalse: [self raiseInvalidAttributeError]