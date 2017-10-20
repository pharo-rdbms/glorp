conversion-strings
convertSQLStringToString: aString for: aType
	aString isNil
		ifTrue: [ ^ nil ].
	^ (self convertSQLStringToByteArray: aString for: aType) asString