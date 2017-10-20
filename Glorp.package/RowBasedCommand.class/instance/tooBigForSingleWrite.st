testing
tooBigForSingleWrite
	^self hasMultipleRows and: [allRows size > self maximumSingleWriteSize].