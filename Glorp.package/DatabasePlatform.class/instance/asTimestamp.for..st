conversion-times
asTimestamp: anObject for: aType
	anObject isNil ifTrue: [^nil].
	^anObject class = Time
		ifTrue: [Dialect newTimestampFromDate: Date today time: anObject]
		ifFalse: [anObject asDateAndTime].