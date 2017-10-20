public
printOn: aStream

	aStream 
		nextPutAll: '<<'.
	self hasValue ifTrue: [aStream print: self contents].
	aStream
		nextPutAll: '>>'