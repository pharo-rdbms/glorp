conversion-strings
convertByteArrayToSQLString: aByteArray for: aType

	^aByteArray ifNotNil: [:array | array asString]