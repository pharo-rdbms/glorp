public
printOn: aStream

	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: (attribute isNil ifTrue: [''] ifFalse: [self attributeName]) ;
		nextPutAll: ')'