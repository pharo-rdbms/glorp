conversion-strings
convertByteArrayToSQLString: aByteArray for: aType
	"This is a slightly misleading name. Really what we want is conversion to a Blob-type of field. So if it's a bytearray, we can just let the driver take care of that conversion, but if we're given a string, we should convert it."

	^aByteArray isString
		ifTrue:
			[Dialect
				convert: aByteArray
				toByteArrayWithEncoding: self characterEncoding]
		ifFalse: [aByteArray].