conversion-boolean
convertTFToBoolean: aString for: aType
	aString isNil ifTrue: [^aString].
	aString = 'T' ifTrue: [^true].
	aString = 'F' ifTrue: [^false].
	self error: 'invalid boolean conversion'.