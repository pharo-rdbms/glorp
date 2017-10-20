conversion-times
dateToTimestampConversion: aDate for: aType
	aDate isNil ifTrue: [^aDate].
	^aDate asTimestamp.