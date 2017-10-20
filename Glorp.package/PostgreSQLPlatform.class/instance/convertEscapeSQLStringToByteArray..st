conversion-strings
convertEscapeSQLStringToByteArray: aString
	^ ByteArray
		new: aString size // 4
		streamContents: [ :out | | in nextChar |
			in := aString readStream.
			[ in atEnd ] whileFalse: [ 
				nextChar := in next.
				out
					nextPut:
						(nextChar = $\
							ifTrue: [ 
								in peek = $\
									ifTrue: [ in next asInteger ]
									ifFalse: [ Number readFrom: (in next: 3) base: 8 ] ]
							ifFalse: [ nextChar asInteger ]) ] ]