iterating
collect: aBlock 
	| newStream |
	newStream := WriteStream on: (Array new: 100).
	[self atEnd] whileFalse: [newStream nextPut: (aBlock value: self next)].
	^newStream contents