printing
printOn: aStream
	aStream nextPutAll: '~~'.
	self describedClass isNil ifFalse: [aStream nextPutAll: self describedClass name].
	aStream nextPutAll: '~~'