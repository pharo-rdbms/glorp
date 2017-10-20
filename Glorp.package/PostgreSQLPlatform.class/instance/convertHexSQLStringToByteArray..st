conversion-strings
convertHexSQLStringToByteArray: aString
	^ ByteArray
		new: aString size // 2 - 1
		streamContents: [ :out | | in |
			(in := aString readStream) skip: 2.
			[ in atEnd ] whileFalse: [ out nextPut: (Number readFrom: (in next: 2) base: 16) ] ]