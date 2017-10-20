conversion-boolean
convertIntegerToBoolean: anInteger for: aType
	anInteger isNil ifTrue: [^anInteger].
	anInteger = 1 ifTrue: [^true].
	anInteger = 0 ifTrue: [^false].
	self error: 'invalid boolean conversion'.