SQL
typeString
	| w |
	platform supportsVariableSizedNumerics ifFalse: [^typeString].
	w := WriteStream on: String new.
	w nextPutAll: typeString.
	precision isNil 
		ifFalse: 
			[w nextPutAll: '(' , precision printString.
			scale isNil ifFalse: [w nextPutAll: ',' , scale printString].
			w nextPutAll: ')'].
	^w contents