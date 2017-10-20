conversion-times
readDate: anObject for: aType
	"From DatabasePlatform."

	anObject isNil ifTrue: [^nil].
	anObject class == Date ifTrue: [^anObject].
	anObject isString ifTrue: [
		^self readDateFromStream: (ReadStream on: anObject) for: aType].
	^anObject asDate.