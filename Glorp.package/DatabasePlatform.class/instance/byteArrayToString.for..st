conversion-strings
byteArrayToString: aByteArray for: aType
	^aByteArray isNil ifTrue: [nil] ifFalse: [Dialect convert: aByteArray toStringWithEncoding: self characterEncoding].