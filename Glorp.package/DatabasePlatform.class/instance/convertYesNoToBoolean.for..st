conversion-boolean
convertYesNoToBoolean: aString for: aType
	aString isNil ifTrue: [^aString].
	aString asUppercase = 'YES' ifTrue: [^true].
	aString asUppercase = 'NO' ifTrue: [^false].
	self error: 'invalid boolean conversion'.