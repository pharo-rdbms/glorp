printing
printOn: aStream
	
	aStream nextPutAll: 'Field'.
	aStream 
		nextPutAll: '(';
		nextPutAll: (table isNil ifTrue: [''] ifFalse: [table name]);
		nextPutAll: '.';
		nextPutAll: name;
		nextPutAll: ')'.