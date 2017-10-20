printing
printOn: aStream

	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: ((schema isNil or: [schema isEmpty]) ifTrue: [''] ifFalse: [schema, '.']);
		nextPutAll: (name isNil ifTrue: [''] ifFalse: [name]);
		nextPutAll: ')'.