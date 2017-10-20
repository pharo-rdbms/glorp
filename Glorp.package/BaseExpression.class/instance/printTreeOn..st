printing
printTreeOn: aStream 
	aStream 
		print: (self descriptor isNil ifTrue: [nil] ifFalse: [self descriptor describedClass])