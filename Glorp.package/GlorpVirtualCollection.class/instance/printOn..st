printing
printOn: aStream
	self isInstantiated
		ifTrue: [super printOn: aStream]
		ifFalse:
			[aStream nextPutAll: 'a virtual collection of '.
			query notNil ifTrue: [aStream nextPutAll: query resultClass name]]