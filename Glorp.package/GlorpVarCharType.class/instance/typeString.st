accessing
typeString
	
	^self typeName,   ( width ifNil: [''] ifNotNil: [ :w |'(', w printString, ')'])