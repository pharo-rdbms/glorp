conversion-times
toTimestamp: anObject for: aType
	"From DatabasePlatform."

	anObject isNil ifTrue: [^nil].
	anObject class = Dialect timestampClass ifTrue: [^anObject].
	anObject isInteger ifTrue: [^anObject].
	^anObject asDateAndTime