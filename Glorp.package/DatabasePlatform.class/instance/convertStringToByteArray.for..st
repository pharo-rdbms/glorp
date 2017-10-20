conversion-strings
convertStringToByteArray: aString for: aType
	^aString ifNotNil:  [aString asByteArray]