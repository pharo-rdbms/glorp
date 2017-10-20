conversion-strings
convertSQLStringToByteArray: aString for: aType

	| aStream str | 
	aString isNil ifTrue: [^nil].
	aStream := (ByteArray new: aString size // 4) writeStream.
	str := aString readStream.
	[str atEnd] whileFalse: [ |nextChar|
		nextChar := str next.
		aStream nextPut: (nextChar = $\
								ifTrue: [str peek = $\
											ifTrue: [str next asInteger]
											ifFalse: [Number readFrom: (str next: 3) base: 8]]
								ifFalse: [nextChar asInteger])
	].
	aStream close.
	^aStream contents