conversion-times
readTime: anObject for: aType
	"format 15:29:28.337-05  (timezone optional)"
	anObject isNil ifTrue: [^nil].
	anObject class == Time ifTrue: [^anObject].
	anObject isString ifTrue: [
		^self readTimeFromStream: (ReadStream on: anObject) for: aType].
	^anObject asTime.