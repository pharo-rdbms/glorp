conversion-numbers
convertToFloat: aNumber for: aType 
	aNumber isNil ifTrue: [^nil].
	^aNumber asFloat.