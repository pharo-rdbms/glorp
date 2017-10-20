conversion-boolean
convertYNToBoolean: aString for: aType
	aString isNil ifTrue: [^aString].
	aString = 'Y' ifTrue: [^true].
	aString = 'N' ifTrue: [^false].
	self error: 'invalid boolean conversion'.