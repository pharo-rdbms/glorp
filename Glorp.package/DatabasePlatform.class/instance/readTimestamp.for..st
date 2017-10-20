conversion-times
readTimestamp: anObject for: aType
	"Seems like we get to do this ourselves, in a lowest common denominator kind of way. Translate into GMT if we've got a timezone."

	"assumes ISO format.
	self readTimestamp: '2003-03-03 15:29:28.337-05' for: nil.
	self readTimestamp: '2003-03-03 19:29:28.337-05' for: nil"

	anObject isNil ifTrue: [^nil].
	anObject class == Dialect timestampClass ifTrue: [^anObject].
	anObject isString
		ifTrue:
			[| stream |
			stream := ReadStream on: anObject.
			^self readTimestampFromStream: stream for: aType].
	^anObject asDateAndTime.