conversion-times
toTime: anObject for: aType
	"From DatabasePlatform."

	anObject isNil ifTrue: [^nil].
	anObject class = Time ifTrue: [^anObject].
	^anObject asTime.