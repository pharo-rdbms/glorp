conversion-times
readDate: anObject for: aType
	"format '2003-03-13"
	anObject isNil ifTrue: [^nil].
	anObject class == Date ifTrue: [^anObject].
	anObject isString ifTrue: [
		^self readDateFromStream: (ReadStream on: anObject) for: aType].
	^anObject asDate.