validation
validateAttribute
	self canWrite ifTrue: [self attribute validateCanWrite].
	self canRead ifTrue: [self attribute validateCanRead]