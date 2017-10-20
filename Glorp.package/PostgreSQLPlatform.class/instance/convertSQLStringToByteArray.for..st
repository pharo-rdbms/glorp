conversion-strings
convertSQLStringToByteArray: aString for: aType
	aString isNil
		ifTrue: [ ^ nil ].
	^ (aString beginsWith: '\x')
		ifTrue: [ self convertHexSQLStringToByteArray: aString ]
		ifFalse: [ self convertEscapeSQLStringToByteArray: aString ]