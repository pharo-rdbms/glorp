conversion-times
toDate: anObject for: aType
	"From DatabasePlatform."

	anObject isNil ifTrue: [^nil].
	anObject class = Date ifTrue: [^anObject].
	anObject isInteger ifTrue: [^anObject].
	^anObject asDate