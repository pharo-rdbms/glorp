conversion-times
toTime: anObject for: aType
	anObject isNil ifTrue: [^nil].
	anObject class = Time ifTrue: [^anObject].
	^anObject asTime.