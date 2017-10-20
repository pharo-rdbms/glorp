conversion-times
readTimestamp: anObject for: aType
	"From DatabasePlatform."

	anObject isNil ifTrue: [^nil].
	anObject class == Dialect timestampClass ifTrue: [^anObject].
	anObject isString
		ifTrue:
			[| stream |
			stream := ReadStream on: anObject.
			^self readTimestampFromStream: stream for: aType].
	^anObject asDateAndTime.