printing
printTreeOn: aStream 
	aStream
		print: base;
		nextPut: $.;
		nextPutAll: (name isString ifTrue: [name] ifFalse: [name printString])