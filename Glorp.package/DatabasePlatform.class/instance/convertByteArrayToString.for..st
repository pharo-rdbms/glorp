conversion-strings
convertByteArrayToString: aByteArray for: aType
	
	^aByteArray ifNotNil: [ aByteArray asString ]