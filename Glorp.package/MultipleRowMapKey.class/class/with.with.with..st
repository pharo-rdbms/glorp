instance creation
with: key1 with: key2 with: key3
	(key1 isNil or: [key2 isNil or: [key3 isNil]]) ifTrue: [self error: 'Nil key in row map, probably indicates an invalid object structure'].
	^self new 
		addKey: key1;
		addKey: key2;
		addKey: key3;
		yourself