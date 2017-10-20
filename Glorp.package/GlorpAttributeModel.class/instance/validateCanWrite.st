validation
validateCanWrite
	self isWritable ifFalse: [self raiseInvalidAttributeError]