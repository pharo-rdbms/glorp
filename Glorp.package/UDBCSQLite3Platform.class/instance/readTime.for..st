conversion-times
readTime: anObject for: aType
	"From DatabasePlatform."

	anObject isNil ifTrue: [^nil].
	anObject class == Time ifTrue: [^anObject].
	anObject isString ifTrue: [
		^self readTimeFromStream: (ReadStream on: anObject) for: aType].
	^anObject asTime.