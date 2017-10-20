printing
printOn: aStream
	super printOn: aStream.
	aStream nextPutAll: ' for '.
	aStream nextPutAll: (resultClass isNil ifTrue: ['nil'] ifFalse: [resultClass name])